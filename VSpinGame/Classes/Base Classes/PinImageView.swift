//
//  PinImageView.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//

import UIKit

class PinImageView: UIImageView {
    private var heightLC: NSLayoutConstraint?
    private var widthLC: NSLayoutConstraint?
    private var topLC: NSLayoutConstraint?
    private var bottomLC: NSLayoutConstraint?
    private var leadingLC: NSLayoutConstraint?
    private var trailingLC: NSLayoutConstraint?
    private var centerXLC: NSLayoutConstraint?
    private var centerYLC: NSLayoutConstraint?
}
extension PinImageView {
    func setupAutoLayout(with preferences: VConfiguration.PinImageViewPreferences?) {
        guard let superView = self.superview else { return }
        guard let preferences = preferences else { return }
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = false
        diactivateConstrains()
        heightLC = self.heightAnchor.constraint(equalToConstant: preferences.size.height)
        heightLC?.isActive = true
        widthLC = self.widthAnchor.constraint(equalToConstant: preferences.size.width)
        widthLC?.isActive = true
        switch preferences.position {
        case .top:
            topLC = self.topAnchor.constraint(equalTo: superView.topAnchor, constant: preferences.verticalOffset)
            topLC?.isActive = true
        case .bottom:
            bottomLC = self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: preferences.verticalOffset)
            bottomLC?.isActive = true
        case .left:
            leadingLC = self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: preferences.horizontalOffset)
            leadingLC?.isActive = true
        case .right:
            trailingLC = self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: preferences.horizontalOffset)
            trailingLC?.isActive = true
        }
        switch preferences.position {
        case .top, .bottom:
            centerXLC = self.centerXAnchor.constraint(equalTo: superView.centerXAnchor, constant: preferences.horizontalOffset)
            centerXLC?.isActive = true
        case .left, .right:
            centerYLC = self.centerYAnchor.constraint(equalTo: superView.centerYAnchor, constant: preferences.verticalOffset)
            centerYLC?.isActive = true
        }
        self.layoutIfNeeded()
    }
    private func diactivateConstrains() {
        heightLC?.isActive = false
        widthLC?.isActive = false
        topLC?.isActive = false
        bottomLC?.isActive = false
        leadingLC?.isActive = false
        trailingLC?.isActive = false
        centerXLC?.isActive = false
        centerYLC?.isActive = false
    }
    func image(name: String?) {
        guard let imageName = name, imageName != "" else {
            let bundle = Bundle(for: VSpinGame.self)
            self.image = self.bundledImage(named: "pin")//UIImage(named: "pin", in: bundle, compatibleWith: nil)
            return
        }
        self.image = UIImage(named: imageName)
    }
    func bundledImage(named: String) -> UIImage? {
        let image = UIImage(named: named)
        if image == nil {
            return UIImage(named: named, in: Bundle(for: VSpinGame.classForCoder()), compatibleWith: nil)
        } // Replace MyBasePodClass with yours
        return image
    }
    func configure(with preferences: VConfiguration.PinImageViewPreferences?) {
        self.backgroundColor = preferences?.backgroundColor
        self.tintColor = preferences?.tintColor
    }
}
