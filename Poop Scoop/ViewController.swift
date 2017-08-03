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
    fileprivate var farts: [AVAudioPlayer] = []
    fileprivate var riddles: [AVAudioPlayer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideRiddle()
        
        startLoadingAnimations()
        DispatchQueue.global(qos: .userInitiated).async {
            self.initializeFarts()
            self.initializeRiddles()
            self.addGestureRecognizers()
            DispatchQueue.main.async {
                self.stopLoadingAnimations()
            }
        }
    }

    deinit {
        farts.forEach { $0.stop() }
        riddles.forEach { $0.stop() }
    }
    
    private func initializeFarts() {
        let fartFileNames = (1...25).map { "Fart \($0)" }
        farts = Array<AVAudioPlayer>(forResources: fartFileNames, ofType: "m4a")
    }
    
    private func initializeRiddles() {
        let fileNames = (1...11).map { "Riddle \($0)" }
        riddles = Array<AVAudioPlayer>(forResources: fileNames, ofType: "m4a")
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
    
    private func startLoadingAnimations() {
        activityIndicator.startAnimating()
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.repeat, UIViewAnimationOptions.autoreverse],
            animations: {
                self.backgroundView.layer.backgroundColor = UIColor.random().cgColor
        })
    }
    
    private func stopLoadingAnimations() {
        activityIndicator.stopAnimating()
        self.backgroundView.layer.removeAllAnimations()
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
        farts.random().play()
    }
    
    private func playRandomRiddle() {
        riddles.random().play()
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
        let scale = 1 + CGFloat.random() / 2
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
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: [UIViewAnimationOptions.allowUserInteraction],
            animations: {
            self.backgroundView.layer.backgroundColor = UIColor.random().cgColor
        })
    }
}
