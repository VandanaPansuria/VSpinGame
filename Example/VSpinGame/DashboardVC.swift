//
//  DashboardVC.swift
//  VSpinGame
//
//  Created by MacV on 08/01/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func onWheelgameTap(_ sender: Any) {
        self.performSegue(withIdentifier: "wheelgame", sender: nil)
    }
}
