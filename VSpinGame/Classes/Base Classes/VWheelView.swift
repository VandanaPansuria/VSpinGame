//
//  VWheelView.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import UIKit

class VWheelView: UIView {
    private(set) var vwheelLayer: VWheelLayer?
    var preferences: VConfiguration.WheelPreferences? {
        didSet {
            vwheelLayer = nil
            addVWheelLayer()
        }
    }
    var slices: [Slice] = [] {
        didSet {
            vwheelLayer?.slices = slices
            self.setNeedsDisplay()
        }
    }
    init(frame: CGRect, slices: [Slice], preferences: VConfiguration.WheelPreferences?) {
        self.preferences = preferences
        self.slices = slices
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.layer.needsDisplayOnBoundsChange = true
    }
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        addVWheelLayer()
    }
    private func addVWheelLayer() {
        for layer in self.layer.sublayers ?? [] {
            layer.removeFromSuperlayer()
        }
        let frame = self.bounds
        vwheelLayer = VWheelLayer(frame: frame, slices: self.slices, preferences: preferences)
        self.layer.addSublayer(vwheelLayer!)
        
        vwheelLayer!.setNeedsDisplay()
    }
}
extension VWheelView {
    func setupAutoLayout() {
        guard let superView = self.superview else { return }
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superView.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: 0).isActive = true
    }
}
