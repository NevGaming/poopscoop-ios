//
//  Random.swift
//  Poop Scoop
//
//  Created by Silas Nevstad on 12/27/16.
//  Copyright © 2016 Silas Nevstad. All rights reserved.
//

import UIKit
import Foundation

extension Int {
    static func random() -> Int {
        return Int(arc4random())
    }
    
    static func random(lower: UInt, upper: UInt) -> Int {
        return Int(UInt.random(lower: lower, upper: upper))
    }
}

extension UInt {
    static func random(lower: UInt, upper: UInt) -> UInt {
        return UInt(arc4random_uniform(UInt32(upper - lower)) + UInt32(lower))
    }
}

extension Double {
    static func random() -> Double {
        return drand48()
    }
}

extension Float {
    static func random() -> Float {
        return Float(Double.random())
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(Double.random())
    }
}

extension Array {
    private var randomIndex: Int {
        return Int.random(lower: 0, upper: UInt(self.count))
    }
    
    func random() -> Element {
        return self[randomIndex]
    }
}

extension UIColor {
    class func random() -> UIColor {
        return UIColor(
            red: CGFloat.random(),
            green: CGFloat.random(),
            blue: CGFloat.random(),
            alpha: 1.0
        )
    }
}

extension UILabel {
    class func randomPoop() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: CGFloat(Int.random(lower: 19, upper: 90)))
        label.text = "💩"
        label.sizeToFit()
        return label
    }
}
