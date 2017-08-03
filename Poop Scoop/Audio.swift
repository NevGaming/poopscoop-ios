//
//  Audio.swift
//  Poop Scoop
//
//  Created by Silas Nevstad on 12/30/16.
//  Copyright © 2016 Silas Nevstad. All rights reserved.
//

import AVFoundation

extension AVAudioPlayer {
    convenience init?(forResource resource: String, ofType type: String) {
        guard let soundFile = Bundle.main.path(forResource: resource, ofType: type) else { return nil }
        do {
            try self.init(contentsOf: URL(fileURLWithPath: soundFile))
            prepareToPlay()
            Logging.debug("Loaded \(soundFile)")
        }
        catch {
            Logging.error("Could not find sound file \(soundFile)")
            return nil
        }
    }
}

extension Array where Element == AVAudioPlayer {
    init(forResources resources: [String], ofType type: String) {
        self.init()
        for resource in resources {
            if let player = AVAudioPlayer(forResource: resource, ofType: type) {
                self.append(player)
            }
        }
    }
}
