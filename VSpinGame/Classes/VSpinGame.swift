//
//  VSpinGame.swift
//  VSpinGame
//
//  Created by vandanapansuria on 01/07/2021.
//  Copyright (c) 2021 vandanapansuria. All rights reserved.
//

import UIKit

enum CollisionType {
    case edge, center
    var identifier: String {
        switch self {
        case .edge:
            return "edgeCollision"
        case .center:
            return "centerCollision"
        }
    }
}

public protocol VSpinGameDelegate {
    
    func onOpen(_ VSpinGame:VSpinGame)
    func onClose(_ VSpinGame:VSpinGame )
    func onError(_ VSpinGame:VSpinGame , requiredArgumentError error : String)
    func onReward(_ VSpinGame:VSpinGame , didGetRewardPoints result : Int)
}

@IBDesignable

public class VSpinGame: UIControl {
   
    public var delegate: VSpinGameDelegate?
    public var onEdgeCollision: ((_ progress: Double?) -> Void)?
    public var onCenterCollision: ((_ progress: Double?) -> Void)?
    public var edgeCollisionDetectionOn: Bool = false
    public var centerCollisionDetectionOn: Bool = false
    public var pinImageViewCollisionEffect: CollisionEffect?
    private var vwheelView: VWheelView?
    private var pinImageView: PinImageView?
    lazy private var animator: SpinningWheelAnimator = SpinningWheelAnimator(withObjectToAnimate: self)
    lazy private var pinImageViewAnimator = PinImageViewCollisionAnimator()
    public var configuration: VConfiguration? {
        didSet {
            updatePreferences()
        }
    }
    open var slices: [Slice] = [] {
        didSet {
            if slices.count < 2{
                self.delegate?.onError(self , requiredArgumentError: "Add at least 2 arguments")
            }else{
                self.delegate?.onOpen(self)
                self.vwheelView?.slices = slices
            }
        }
    }
    private var _pinImageName: String? {
        didSet {
            pinImageView?.image(name: _pinImageName)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.vwheelView = VWheelView(coder: aDecoder)
        super.init(coder: aDecoder)
        setup()
    }
    private func setup() {
        setupVWheelView()
        setupPinImageView()
    }
    private func setupSnapAnimator() {
        guard let pinImageView = self.pinImageView else { return }
        pinImageViewAnimator.prepare(referenceView: self, pinImageView: pinImageView)
    }
    private func setupPinImageView() {
        guard let pinPreferences = configuration?.pinPreferences else {
            self.pinImageView?.removeFromSuperview()
            self.pinImageView = nil
            return
        }
        if self.pinImageView == nil {
            pinImageView = PinImageView()
        }
        if !self.isDescendant(of: pinImageView!) {
            self.addSubview(pinImageView!)
        }
        pinImageView?.setupAutoLayout(with: pinPreferences)
        pinImageView?.configure(with: pinPreferences)
        pinImageView?.image(name: _pinImageName)
    }
    private func setupVWheelView() {
        guard let vwheelView = vwheelView else { return }
        self.addSubview(vwheelView)
        vwheelView.setupAutoLayout()
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        setupSnapAnimator()
    }
    private func updatePreferences() {
        self.vwheelView?.preferences = configuration?.wheelPreferences
        setupPinImageView()
    }
}
// MARK: - SliceCalculating
extension VSpinGame: SliceCalculating {}

// MARK: - SpinningAnimatorProtocol
extension VSpinGame: SpinningAnimatorProtocol {
    var layerToAnimate: SpinningAnimatable? {
        let layer = self.vwheelView?.vwheelLayer
        self.vwheelView?.setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 0.5))
        return layer
    }
    var sliceDegree: CGFloat? {
        return 360.0 / CGFloat(slices.count)
    }
    var edgeAnchorRotationOffset: CGFloat {
        return configuration?.wheelPreferences.imageAnchor?.rotationDegreeOffset ?? 0
    }
    var centerAnchorRotationOffset: CGFloat {
        return configuration?.wheelPreferences.centerImageAnchor?.rotationDegreeOffset ?? 0
    }
}
// MARK: - API
public extension VSpinGame {
    func rotate(toIndex index: Int, animationDuration: CFTimeInterval = 0.00001) {
        let _index = index < self.slices.count ? index : self.slices.count - 1
        let rotation = 360.0 - computeRadian(from: _index)
        guard animator.currentRotationPosition != rotation else { return }
        self.onStop()
        self.animator.addRotationAnimation(fullRotationsCount: 0,
                                           animationDuration: animationDuration,
                                           rotationOffset: rotation,
                                           completionBlock: nil)
    }
    func rotate(rotationOffset: CGFloat, animationDuration: CFTimeInterval = 0.00001) {
        guard animator.currentRotationPosition != rotationOffset else { return }
        self.onStop()
        self.animator.addRotationAnimation(fullRotationsCount: 0,
                                           animationDuration: animationDuration,
                                           rotationOffset: rotationOffset,
                                           completionBlock: nil)
    }
    func onStart(rotationOffset: CGFloat, fullRotationsCount: Int = 13, animationDuration: CFTimeInterval = 5.000, _ completion: ((Bool) -> Void)?) {
        DispatchQueue.main.async {
            self.onStop()
            self.animator.addRotationAnimation(fullRotationsCount: fullRotationsCount, animationDuration: animationDuration, rotationOffset: rotationOffset, completionBlock: completion, onEdgeCollision: { [weak self] progress in                        self?.impactIfNeeded(for: .edge)
                self?.onEdgeCollision?(progress)
            })
            { [weak self] (progress) in
                self?.impactIfNeeded(for: .center)
                self?.onCenterCollision?(progress)
            }
        }
    }
    fileprivate func impactIfNeeded(for type: CollisionType) {
        pinImageViewAnimator.movePinIfNeeded(collisionEffect: self.pinImageViewCollisionEffect, position: self.configuration?.pinPreferences?.position)
        //impactFeedbackIfNeeded(for: type)
    }
    func onStart(finishIndex: Int, fullRotationsCount: Int = 13, animationDuration: CFTimeInterval = 5.000, _ completion: ((Bool) -> Void)?) {
        let _index = finishIndex < self.slices.count ? finishIndex : self.slices.count - 1
        let rotation = 360.0 - computeRadian(from: _index)
        self.onStart(rotationOffset: rotation,
                                    fullRotationsCount: fullRotationsCount,
                                    animationDuration: animationDuration,
                                    completion)
    }
    func onStart(finishIndex: Int, continuousRotationTime: Int, continuousRotationSpeed: CGFloat = 4, _ completion: ((Bool) -> Void)?) {

        let _index = finishIndex < self.slices.count ? finishIndex : self.slices.count - 1
        self.startContinuousRotationAnimation(with: continuousRotationSpeed)
        let deadline = DispatchTime.now() + DispatchTimeInterval.seconds(continuousRotationTime)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.onStart(finishIndex: _index) { (finished) in
                completion?(finished)
                self.delegate?.onReward(self, didGetRewardPoints: finishIndex)
            }
        }
    }
    func onStart(finishIndex: Int, continuousRotationTime: Int, continuousRotationSpeed: CGFloat = 4, rotationOffset: CGFloat = 0, _ completion: ((Bool) -> Void)?) {
        let _index = finishIndex < self.slices.count ? finishIndex : self.slices.count - 1
        let rotation = 360.0 - computeRadian(from: _index) + rotationOffset
        self.startContinuousRotationAnimation(with: continuousRotationSpeed)
        let deadline = DispatchTime.now() + DispatchTimeInterval.seconds(continuousRotationTime)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.onStart(rotationOffset: rotation) { (finished) in
                print(self.slices[finishIndex])
                completion?(finished)
            }
        }
    }
    func startContinuousRotationAnimation(with speed: CGFloat = 4) {
        self.onStop()
        self.animator.addIndefiniteRotationAnimation(speed: speed, onEdgeCollision: { [weak self] progress in
            self?.impactIfNeeded(for: .edge)
            self?.onEdgeCollision?(progress)
        })
        { [weak self] (progress) in
            self?.impactIfNeeded(for: .center)
            self?.onCenterCollision?(progress)
        }
    }
    func onStop() {
        self.delegate?.onClose(self)
        self.animator.stop()
    }
    func onStart(finishIndex: Int, rotationOffset: CGFloat, fullRotationsCount: Int = 13, animationDuration: CFTimeInterval = 5.000, _ completion: ((Bool) -> Void)?) {
        let _index = finishIndex < self.slices.count ? finishIndex : self.slices.count - 1
        let rotation = 360.0 - computeRadian(from: _index) + rotationOffset
        self.onStart(rotationOffset: rotation,
                                    fullRotationsCount: fullRotationsCount,
                                    animationDuration: animationDuration,
                                    completion)
    }
}
public extension VSpinGame {
    @IBInspectable var pinImage: String? {
        set { _pinImageName = newValue }
        get { return _pinImageName }
    }
    @IBInspectable var isPinHidden: Bool {
        set { pinImageView?.isHidden = newValue }
        get { return pinImageView?.isHidden ?? false }
    }
}
public extension VSpinGame {
    
    @available(*, deprecated, message: "Use startContinuousRotationAnimation(with: speed) instead")
    func startAnimating(rotationTime: CFTimeInterval = 5.000, fullRotationCountInRotationTime: CGFloat = 7000) {
        self.stopAnimating()
        let speed = fullRotationCountInRotationTime / (360 * CGFloat(rotationTime))
        startContinuousRotationAnimation(with: speed)
    }
    @available(*, deprecated, renamed: "onStop")
    func stopAnimating() {
        self.onStop()
    }
    @available(*, deprecated, message: "Use onStart(finishIndex:continuousRotationTime:completion:) instead")
    func startAnimating(indefiniteRotationTimeInSeconds: Int, finishIndex: Int, _ completion: ((Bool) -> Void)?) {
        self.onStart(finishIndex: finishIndex, continuousRotationTime: indefiniteRotationTimeInSeconds, completion)
    }
    @available(*, deprecated, renamed: "onStart(finishIndex:rotationOffset:fullRotationsCount:animationDuration:completion:)")
    func startAnimating(finishIndex: Int, rotationOffset: CGFloat, fullRotationsUntilFinish: Int = 13, animationDuration: CFTimeInterval = 5.000, _ completion: ((Bool) -> Void)?) {
        self.onStart(finishIndex: finishIndex, rotationOffset: rotationOffset, fullRotationsCount: fullRotationsUntilFinish, animationDuration: animationDuration, completion)
    }
    @available(*, deprecated, renamed: "onStart(rotationOffset:fullRotationsCount:animationDuration:completion:)")
    func startAnimating(rotationOffset: CGFloat, fullRotationsUntilFinish: Int = 13, animationDuration: CFTimeInterval = 5.000, _ completion: ((Bool) -> Void)?) {
        self.onStart(rotationOffset: rotationOffset, fullRotationsCount: fullRotationsUntilFinish, animationDuration: animationDuration, completion)
    }
    @available(*, deprecated, renamed: "onStart(finishIndex:fullRotationsCount:animationDuration:completion:)")
    func startAnimating(finishIndex: Int, fullRotationsUntilFinish: Int = 13, animationDuration: CFTimeInterval = 5.000, _ completion: ((Bool) -> Void)?) {
        self.onStart(finishIndex: finishIndex, fullRotationsCount: fullRotationsUntilFinish, animationDuration: animationDuration, completion)
    }
}

