//
//  ImpactFeedbackable.swift
//  VSpinGame
//
//  Created by MacV on 07/01/21.
//
import UIKit
protocol ImpactFeedbackable {
    @available(iOS 10.0, iOSApplicationExtension 10.0, *)
    var impactFeedbackgenerator: UIImpactFeedbackGenerator { get }
    var impactFeedbackOn: Bool { get set }
}
extension ImpactFeedbackable {
    func prepareImpactFeedbackIfNeeded() {
        if #available(iOS 10.0, iOSApplicationExtension 10.0, *) {
            guard impactFeedbackOn == true else { return }
            impactFeedbackgenerator.prepare()
        } else {
            // Fallback
        }
    }
    func impactFeedback() {
        if #available(iOS 10.0, iOSApplicationExtension 10.0, *) {
            if impactFeedbackOn {
                impactFeedbackgenerator.impactOccurred()
            }
        } else {
            // Fallback
        }
    }
}
