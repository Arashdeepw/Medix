//
//  HomeViewController.swift
//  MedixFinalProject
//
//  Created by Gabby
//  Copyright © 2020 Xcode User. All rights reserved.
//logged in user home screen, can access other elements of app

import UIKit

class HomeViewController: UIViewController {
    
    // Define CA layer
    var fadeLayer : CALayer?
    
    // Segue
    @IBAction func unwindToLoggedInHomeVC(sender : UIStoryboardSegue) { }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Fade animation steps
        // Instantiate img object
        let fadeImg = UIImage(named: "appTitle.png")
        
        // Instantiate fade layer - 3rd method
        fadeLayer = CALayer()
        
        // Feed contents from img to layer
        fadeLayer?.contents = fadeImg?.cgImage
        
        // Specify size
        fadeLayer?.bounds = CGRect(x: 0, y: 0, width: 186, height: 69)
        
        // Specify postion
        fadeLayer?.position = CGPoint(x: 205, y: 850)
        
        // Add to screen
        view.layer.addSublayer(fadeLayer!)
        
        // Fading animation
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        
        // Timing function
        fadeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // FROM value
        // Alpha values 1 is fully visible and 0 is invisible
        fadeAnimation.fromValue = 1.0
        
        // TO value
        fadeAnimation.toValue = 0.0
        
        // Needed
        fadeAnimation.isRemovedOnCompletion = false
        
        // Duration in seconds
        fadeAnimation.duration = 2.0
        
        // Delays for 1 second
        fadeAnimation.beginTime = 1.0
        
        // Accumalated fade
        fadeAnimation.isAdditive = false
        
        // When to pause the rotation cycle
        // Ability to have the animation to freeze at the beginning and end for better view of the animation
        fadeAnimation.fillMode = .both
        
        // Loop
        fadeAnimation.repeatCount = .infinity
        
        // fades in - fades out
        // applies to all animations
        fadeAnimation.autoreverses = true
        
        // Add to fade layer
        fadeLayer?.add(fadeAnimation, forKey: nil)
    }
    

}
