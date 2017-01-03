//
//  Logging.swift
//  Poop Scoop
//
//  Created by Silas Nevstad on 12/30/16.
//  Copyright © 2016 Silas Nevstad. All rights reserved.
//

import Foundation

class Logging {
    class func debug(_ string: String) {
        #if DEBUG
            print("DEBUG: \(string)")
        #endif        
    }
    
    class func error(_ string: String) {
        print("ERROR: \(string)")
    }
}
