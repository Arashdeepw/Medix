//
//  ViewController.swift
//  MedixFinalProject
//
//  Created by Arashdeep
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func unwindToHomeVC(sender : UIStoryboardSegue){}
    
    @IBOutlet var tfName : UITextField!
    @IBOutlet var tfPass : UITextField!
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func login(sender: UIButton){
        let name = tfName.text
        let pass = tfPass.text
        var check = false
        for user in mainDelegate.users{
            if(user.name == name && user.pass == pass){
                mainDelegate.userIndex = mainDelegate.users.index(of: user)
                check = true
            }
        }
        
        if (!check){
            let alertBox = UIAlertController(title: "Warning", message: "Wrong Information", preferredStyle: .alert)
            alertBox.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
            alertBox.addAction(UIAlertAction(title: "Register", style: .default, handler: {(action) -> Void in self.moveToRegister()}))
            present(alertBox,animated: true)
        }
        else{
            performSegue(withIdentifier: "login", sender: nil)
        }
    }
    func moveToRegister(){
        performSegue(withIdentifier: "register", sender: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

