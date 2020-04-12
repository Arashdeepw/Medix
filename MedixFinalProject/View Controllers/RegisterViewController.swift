//
//  RegisterViewController.swift
//  MedixFinalProject
//
//  Created by Arashdeep
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var tfName : UITextField!
    @IBOutlet var tfPass : UITextField!
    @IBOutlet var avatarPic: UISegmentedControl!
    @IBOutlet var ageSlider : UISlider!
    @IBOutlet var lbSlider : UILabel!
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func updateAge(){
        let age = ageSlider.value
        let strAge = String(format: "%.0f",age)
        lbSlider.text = strAge
    }
    @IBAction func sliderValueChange(sender: UISlider){
        updateAge()
    }
    
    
    @IBAction func registerData(sender: UIButton){
        let name = tfName.text!
        let pass = tfPass.text!
        let avatar = avatarPic.titleForSegment(at: avatarPic.selectedSegmentIndex)
        let age = ageSlider.value
        let user = RegisterData.init()
        user.initWithData(theName: name, thePass: pass, theAvatar: avatar!, theAge: Int(age))
        mainDelegate.users.append(user)
        
        let alertBox = UIAlertController(title: "Thank you!",
                                         message: "Name: "+name+" Pass: "+pass, preferredStyle: .alert)
        let homeAction = UIAlertAction(title: "HOME", style: .default) {//yes button
            (alert) in self.performSegue(withIdentifier: "unwindToHome", sender: self)
            self.dismiss(animated: true, completion: nil)
        }
        alertBox.addAction(homeAction)
        present(alertBox,animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateAge()
    }
    

}
