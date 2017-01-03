//
//  Random.swift
//  Poop Scoop
//
//  Created by Silas Nevstad on 12/27/16.
//  Copyright © 2016 Silas Nevstad. All rights reserved.
//

import UIKit

extension UIColor {
    class var random: UIColor {
        return UIColor(
            red: CGFloat(drand48()),
            green: CGFloat(drand48()),
            blue: CGFloat(drand48()),
            alpha: 1.0
        )
    }
}

extension UILabel {
    class var randomSizedPoop: UILabel {
        let randomSize = max(15, arc4random_uniform(90))
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: CGFloat(randomSize))
        label.text = "💩"
        label.sizeToFit()
        return label
    }
    
    class var riddle  : UILabel {
        let size = 24
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: CGFloat(size))
        label.text = "💩 How much Poop can a Poop Scooper Scoop if a Poop Scooper could Scoop Poop 💩"
        label.sizeToFit()
        return label
    }
}
