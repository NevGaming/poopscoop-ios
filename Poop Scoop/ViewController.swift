//
//  ViewController.swift
//  Poop Scoop
//
//  Created by Silas Nevstad on 12/27/16.
//  Copyright © 2016 Silas Nevstad. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var riddle: UILabel!
    
    private var poops: [UILabel] = []
    private var farts: [AVAudioPlayer?] = []
    
    private var riddles: [AVAudioPlayer?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        riddle.isHidden = true
        
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            self.initializeFarts()
            self.initializeRiddles()
            self.addGestureRecognizers()
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func initializeFarts() {
        for num in 1...25 {
            if let player = Audio.buildAudioPlayer(forResource: "Fart \(num)", ofType: "m4a") {
                farts.append(player)
            }
        }
    }
    
    private func initializeRiddles() {
        for num in 1...11 {
            if let riddle = Audio.buildAudioPlayer(forResource: "Riddle \(num)", ofType: "m4a") {
                riddles.append(riddle)
            }
        }
    }
    
    private func addGestureRecognizers() {
        // Listen for user taps with one finger, to app poop
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(sender:)))
        tap.numberOfTapsRequired = 1
        self.backgroundView.addGestureRecognizer(tap)
        
        // Listen for user double-taps with two finger, to remove all poop
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(removeAllPoops))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 2
        self.backgroundView.addGestureRecognizer(doubleTap)
        
        let tripleTap = UITapGestureRecognizer(target: self, action: #selector(showRiddle))
        tripleTap.numberOfTapsRequired = 3
        tripleTap.numberOfTouchesRequired = 2
        self.backgroundView.addGestureRecognizer(tripleTap)
    }
    
    @objc private func showRiddle() {
        riddle.isHidden = false
        playRandomRiddle()
        removeAllPoops()
    }
    
    @objc private func backgroundTapped(sender: UITapGestureRecognizer) {
        playRandomFart()
        addRandomPoop(atLocation: sender.location(ofTouch: 0, in: backgroundView))
        changeRandomBackgroundColor()
    }
    
    private func playRandomFart() {
        playRandomSound(inCollection: farts)
    }
    
    private func playRandomRiddle() {
        playRandomSound(inCollection: riddles)
    }
    
    private func playRandomSound(inCollection collection: [AVAudioPlayer?]) {
        let index = Int(arc4random_uniform(UInt32(collection.count)))
        let sound = collection[index]
        sound?.play()
    }
    
    private func addRandomPoop(atLocation location: CGPoint) {
        // hide the riddle if already shown
        riddle.isHidden  = true
        
        // Creates a random sized poop placed where the user tapped
        let poop = UILabel.randomSizedPoop
        poop.frame.origin = CGPoint(
            x: location.x - poop.frame.size.width / 2,
            y: location.y - poop.frame.size.height / 2
        )
        backgroundView.addSubview(poop)
        poops.append(poop)
        
        // Animates the poop in a bouncy way, repeats forever
        UIView.animate(
            withDuration: 0.35,
            delay: 0,
             usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.8,
            options: [.autoreverse, .repeat],
            animations: {
                poop.layer.transform = CATransform3DScale(poop.layer.transform, 1.3, 1.3, 1.3)
        }, completion: nil)

    }
    
    @objc private func removeAllPoops() {
        poops.forEach { $0.removeFromSuperview() }
        poops.removeAll()
    }
    
    private func changeRandomBackgroundColor() {
        // Animates changing the background color to a random color
        UIView.animate(withDuration: 0.15) {
            self.backgroundView.layer.backgroundColor = UIColor.random.cgColor
        }
    }
}





