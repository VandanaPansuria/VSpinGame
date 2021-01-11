# VSpinGame

[![CI Status](https://img.shields.io/travis/vandanapansuria/VSpinGame.svg?style=flat)](https://travis-ci.org/vandanapansuria/VSpinGame)
[![Version](https://img.shields.io/cocoapods/v/VSpinGame.svg?style=flat)](https://cocoapods.org/pods/VSpinGame)
[![License](https://img.shields.io/cocoapods/l/VSpinGame.svg?style=flat)](https://cocoapods.org/pods/VSpinGame)
[![Platform](https://img.shields.io/cocoapods/p/VSpinGame.svg?style=flat)](https://cocoapods.org/pods/VSpinGame)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

    * iOS 10.0+
    * Xcode 11+
    * Swift 5.0+

## Installation

VSpinGame is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'VSpinGame'
```

# Initializing and Usage

## Integrate

Import VSpinGame into ViewController.swift
![alt text](https://github.com/VandanaPansuria/VSpinGame/blob/master/Example/images/Screenshot%20at%20Jan%2011%2011-17-40.png)

Then click on the UIView you added and go to the Identity Inspector. Set the class to VSpinGame:
![alt text](https://github.com/VandanaPansuria/VSpinGame/blob/master/Example/images/Screenshot%20at%20Jan%2011%2011-15-51.png)

Initialize VSpinGame within
```swift
class ViewController: UIViewController {
    @IBOutlet weak var wheelGame: VSpinGame! {
        didSet {
            wheelGame.delegate = self
            wheelGame.configuration = .vWheelspinconfiguration
            wheelGame.slices = slices
            wheelGame.pinImage = "pin"
            wheelGame.pinImageViewCollisionEffect = CollisionEffect(force: 8, angle: 20)
            wheelGame.edgeCollisionDetectionOn = true
            }
        }
        //Here VDict is a model of response 
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
}
```
##### Configuration

You can inject `Configuration` instance to VSpinGame, which allows you to configure text, colors, fonts and  slice background color features

```swift
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
```

Now let's connect these to outlets. and connect it to an Outlet named wheelGame.
![alt text](https://github.com/VandanaPansuria/VSpinGame/blob/master/Example/images/Screenshot%20at%20Jan%2011%2011-16-59.png)

We want to make the View Controller implement the VSpinGameDelegate protocol, At this point ViewController.Swift should look like the following:

```swift
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
        let rewardvalue =  VSpinGame.slices[0].objArray[result] as! VDict
        print("Reward :", rewardvalue.value)
    }
}
```
When wheel start to rotate, it will execute `onStart` method with instance of VSpinGame. it will look like the following :
```swift
@IBAction func onStartTap(_ sender: UIButton) {
    wheelGame.onStart(finishIndex: finishIndex, continuousRotationTime: 1) { (finished) in
        //print(self.finishIndex)
    }
}
```

Starts indefinite rotation and stops rotation at the specified index
## Author

vandanapansuria, vandanapansuria@gmail..com

## License

VSpinGame is available under the MIT license. See the LICENSE file for more info.
