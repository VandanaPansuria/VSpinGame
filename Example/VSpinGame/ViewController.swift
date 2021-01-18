//
//  ViewController.swift
//  VSpinGame
//
//  Created by vandanapansuria on 01/09/2021.
//  Copyright (c) 2021 vandanapansuria. All rights reserved.
//

import UIKit
import VSpinGame

//MARK:- JSON Model
struct VDict {
  var id:String
  var displayText:String
  var value : String
  var currency : String

  var asDictionary : [String:Any] {
    let mirror = Mirror(reflecting: self)
    let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
      guard let label = label else { return nil }
      return (label, value)
    }).compactMap { $0 })
    return dict
  }
}

//MARK:- ViewController
class ViewController: UIViewController {
    @IBOutlet weak var wheelGame: VSpinGame! {
        didSet {
            wheelGame.delegate = self
           // wheelGame.configuration = .vWheelspinconfiguration
            wheelGame.slices = slices
            //wheelGame.pinImage = "pin"
            //wheelGame.pinImageViewCollisionEffect = CollisionEffect(force: 8, angle: 20)
            //wheelGame.edgeCollisionDetectionOn = true
        }
    }
    let p1 = VDict(id: "1", displayText: "$50", value: "50", currency: "USD")
    let p2 = VDict(id: "2", displayText: "$100", value: "100", currency: "USD")
    let p3 = VDict(id: "3", displayText: "$50", value: "50", currency: "USD")
    let p4 = VDict(id: "4", displayText: "$100", value: "100", currency: "USD")
    let p5 = VDict(id: "5", displayText: "$50", value: "50", currency: "USD")
    let p6 = VDict(id: "6", displayText: "$100", value: "100", currency: "USD")
    let p7 = VDict(id: "7", displayText: "$50", value: "50", currency: "USD")
    let p8 = VDict(id: "8", displayText: "$100", value: "100", currency: "USD")
    var objarray : Array<VDict> = []
  
    lazy var slices: [Slice] = {
        objarray =  [p1,p2,p3,p4,p5,p6,p7,p8]
        let slices = objarray.map({ Slice.init(contents: [Slice.ContentType.text(text: $0.displayText, preferences: .WheelText)], objArray: objarray) })
        return slices
    }()
  
    var finishIndex: Int {
        return Int.random(in: 0..<wheelGame.slices.count)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
    }
    
    @IBAction func onStartTap(_ sender: UIButton) {
        wheelGame.onStart(finishIndex: finishIndex, continuousRotationTime: 1) { (finished) in
            //print(self.finishIndex)
        }
    }
    @IBAction func btnBack(_ sender: Any) {
        wheelGame.onStop()
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- VSpinGameDelegate
extension ViewController : VSpinGameDelegate{
    func onOpen(_ VSpinGame: VSpinGame) {
        //print("open")
    }
    func onError(_ VSpinGame: VSpinGame, requiredArgumentError error: String) {
        print(error)
    }
    
    func onClose(_ VSpinGame: VSpinGame) {
        //print("close")
    }
    //onReward
    func onReward(_ VSpinGame: VSpinGame, didGetRewardPoints result: Int) {
        let sd =  VSpinGame.slices[0].objArray[result] as! VDict
        print("Reward :", sd.value)
    }
    
}
//MARK:- spinConfiguration
public extension VConfiguration {
    static var vWheelspinconfiguration: VConfiguration {
        let pin = VConfiguration.PinImageViewPreferences(size: CGSize(width: 30,height: 50), position: .top, verticalOffset: -20)
        let sliceBackgroundColorType = VConfiguration.ColorType.evenOddColors(evenColor:  #colorLiteral(red: 0.07843137255, green: 0.1019607843, blue: 0.1176470588, alpha: 1), oddColor: #colorLiteral(red: 0.01568627451, green: 0.05098039216, blue: 0.07843137255, alpha: 1))
        let slicePreferences = VConfiguration.SlicePreferences(backgroundColorType: sliceBackgroundColorType, strokeWidth: 0, strokeColor: #colorLiteral(red: 0.07843137255, green: 0.1019607843, blue: 0.1176470588, alpha: 1))
        let circlePreferences = VConfiguration.CirclePreferences(strokeWidth: 14, strokeColor: #colorLiteral(red: 0.07843137255, green: 0.1019607843, blue: 0.1176470588, alpha: 1))
        let wheelPreferences = VConfiguration.WheelPreferences(circlePreferences: circlePreferences, slicePreferences: slicePreferences, startPosition: .top)
        let configuration = VConfiguration(wheelPreferences: wheelPreferences, pinPreferences: pin)
        return configuration
    }
}
//MARK:- spinText
public extension TextPreferences {
    static var WheelText: TextPreferences {
        var textPreferences = TextPreferences(textColorType: VConfiguration.ColorType.customPatternColors(colors: nil, defaultColor: .white),font: .systemFont(ofSize: 16, weight: .bold),verticalOffset: 12)
        textPreferences.orientation = .vertical
        textPreferences.horizontalOffset = 0
        textPreferences.alignment = .right
        return textPreferences
    }
}

