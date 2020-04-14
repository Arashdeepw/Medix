//
//  ViewController.swift
//  MedixFinalProject
//
//  Created by Arashdeep
//  Copyright © 2020 Xcode User. All rights reserved.
//home page used for loging in user

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate, AVAudioPlayerDelegate {
    //unwind segue
    @IBAction func unwindToHomeVC(sender : UIStoryboardSegue){}
    
    @IBOutlet var tfName : UITextField!
    @IBOutlet var tfPass : UITextField!
    var fadeLayer : CALayer?
    var soundPlayer : AVAudioPlayer?
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    //login button
    @IBAction func login(sender: UIButton){
        let name = tfName.text
        let pass = tfPass.text
        var check = false
        //does a loop through user objects to see if the user is registered
        for user in mainDelegate.users{
            if(user.name == name && user.pass == pass){
                mainDelegate.userIndex = mainDelegate.users.index(of: user)
                check = true
            }
        }
        //if the user is not register, alert and gives them option to register or try again
        if (!check){
            let alertBox = UIAlertController(title: "Warning", message: "Wrong Information", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
            alertBox.addAction(UIAlertAction(title: "Register", style: .default, handler: {(action) -> Void in self.moveToRegister()}))
            present(alertBox,animated: true)
        }
        else{
            soundPlayer?.stop() // stops the sound
            performSegue(withIdentifier: "login", sender: nil)
        }
    }
    //function for segue
    func moveToRegister(){
        performSegue(withIdentifier: "register", sender: nil)
    }
    //textfield function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    //audio
    override func viewWillAppear(_ animated: Bool) {
        let soundUrl = Bundle.main.path(forResource: "jazz", ofType: "mp3")
        let url = URL(fileURLWithPath: soundUrl!)
        soundPlayer = try! AVAudioPlayer.init(contentsOf: url)
        soundPlayer?.currentTime = 0 //start at 0 sec
        soundPlayer?.volume = 1
        soundPlayer?.numberOfLoops = -1
        soundPlayer?.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fade animation
        let fadeImg = UIImage(named: "logo.png")
        fadeLayer = CALayer()
        fadeLayer?.contents = fadeImg?.cgImage
        fadeLayer?.bounds = CGRect(x: 0, y: 0, width: 186, height: 150)
        fadeLayer?.position = CGPoint(x: 205, y: 150)
        view.layer.addSublayer(fadeLayer!)
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        fadeAnimation.fromValue = 1.0
        fadeAnimation.toValue = 0.0
        fadeAnimation.isRemovedOnCompletion = false
        fadeAnimation.duration = 2.0
        fadeAnimation.beginTime = 1.0
        fadeAnimation.isAdditive = false
        fadeAnimation.fillMode = .both
        fadeAnimation.repeatCount = .infinity
        fadeAnimation.autoreverses = true
        fadeLayer?.add(fadeAnimation, forKey: nil)
    }
}

