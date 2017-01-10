//
//  Random.swift
//  Poop Scoop
//
//  Created by Silas Nevstad on 12/27/16.
//  Copyright © 2016 Silas Nevstad. All rights reserved.
//

import UIKit

class Random {
    class func int() -> Int {
        return Int(arc4random())
    }
    
    class func int(between minValue: UInt, and maxValue: UInt) -> Int {
        return Int(max(minValue, UInt(arc4random_uniform(UInt32(maxValue)))))
    }
    
    class func double() -> Double {
        return drand48()
    }
    
    class func float() -> Float {
        return Float(double())
    }

    class func float() -> CGFloat {
        return CGFloat(double())
    }
}

extension Array {
    var randomIndex: Int {
        return Random.int(between: 0, and: UInt(self.count))
    }
    
    func random() -> Element {
        return self[randomIndex]
    }
}

extension UIColor {
    class func random() -> UIColor {
        return UIColor(
            red: Random.float(),
            green: Random.float(),
            blue: Random.float(),
            alpha: 1.0
        )
    }
}

extension UILabel {
    class func randomPoop() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: CGFloat(Random.int(between: 19, and: 90)))
        label.text = "💩"
        label.sizeToFit()
        return label
    }
}
