//
//  Audio.swift
//  Poop Scoop
//
//  Created by Silas Nevstad on 12/30/16.
//  Copyright © 2016 Silas Nevstad. All rights reserved.
//

import AVFoundation

class Audio {
    class func buildAudioPlayer(forResource resource: String, ofType type: String) -> AVAudioPlayer? {
        if let soundFile = Bundle.main.path(forResource: resource, ofType: type) {
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundFile))
                audioPlayer.prepareToPlay()
                Logging.debug("Loaded \(soundFile)")
                return audioPlayer
            }
            catch {
                Logging.error("Could not find sound file \(soundFile)")
            }
        }
        return nil
    }
}
