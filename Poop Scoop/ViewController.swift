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
    
    fileprivate var poops: [UILabel] = []
    fileprivate var farts: [AVAudioPlayer?] = []
    fileprivate var riddles: [AVAudioPlayer?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideRiddle()
        
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
        
        // Listen for user double-taps with two fingers, to remove all poop
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(removeAllPoops))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 2
        self.backgroundView.addGestureRecognizer(doubleTap)
        
        // Listen for user triple-taps with two fingers, to remove all poos and show riddle
        let tripleTap = UITapGestureRecognizer(target: self, action: #selector(showRiddle))
        tripleTap.numberOfTapsRequired = 3
        tripleTap.numberOfTouchesRequired = 2
        self.backgroundView.addGestureRecognizer(tripleTap)
    }
}

extension ViewController {
    
    @objc fileprivate func backgroundTapped(sender: UITapGestureRecognizer) {
        hideRiddle()
        playRandomFart()
        addRandomPoop(atLocation: sender.location(ofTouch: 0, in: backgroundView))
        changeRandomBackgroundColor()
    }
    
    @objc fileprivate func removeAllPoops() {
        poops.forEach { $0.removeFromSuperview() }
        poops.removeAll()
    }
    
    @objc fileprivate func showRiddle() {
        riddle.isHidden = false

        playRandomRiddle()
        removeAllPoops()
    }
    
    fileprivate func hideRiddle() {
        riddle.isHidden  = true
    }

    private func playRandomFart() {
        farts.random()?.play()
    }
    
    private func playRandomRiddle() {
        riddles.random()?.play()
    }
    
    private func addRandomPoop(atLocation location: CGPoint) {
        // Creates a random sized poop placed where the user tapped
        let poop = UILabel.randomPoop()
        poop.frame.origin = CGPoint(
            x: location.x - poop.frame.size.width / 2,
            y: location.y - poop.frame.size.height / 2
        )
        backgroundView.addSubview(poop)
        poops.append(poop)
        
        // Animates the poop in a bouncy way, repeats forever
        let scale: CGFloat = 1 + Random.float() / 2
        UIView.animate(
            withDuration: 0.35,
            delay: 0,
             usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.8,
            options: [.autoreverse, .repeat],
            animations: {
                poop.layer.transform = CATransform3DScale(poop.layer.transform, scale, scale, scale)
        }, completion: nil)
    }
    
    private func changeRandomBackgroundColor() {
        // Animates changing the background color to a random color
        let randomColor = UIColor.random()
        UIView.animate(withDuration: 0.15) {
            self.backgroundView.layer.backgroundColor = randomColor.cgColor
        }
    }
}
