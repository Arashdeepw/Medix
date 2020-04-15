//
//  RegisterViewController.swift
//  MedixFinalProject
//
//  Created by Arashdeep
//  Copyright © 2020 Xcode User. All rights reserved.
//page for registering user

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    //variables
    @IBOutlet var tfName : UITextField!
    @IBOutlet var tfPass : UITextField!
    @IBOutlet var tfNumb : UITextField!
    @IBOutlet var avatarPic: UISegmentedControl!
    @IBOutlet var ageSlider : UISlider!
    @IBOutlet var lbSlider : UILabel!
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    //function to update age
    func updateAge(){
        let age = ageSlider.value
        let strAge = String(format: "%.0f",age)
        lbSlider.text = strAge
    }
    //calls function on slider change
    @IBAction func sliderValueChange(sender: UISlider){
        updateAge()
    }
    
    //Register User on Button Action
    @IBAction func registerData(sender: UIButton){
        //error check to make sure fields are filled
        if tfName.text!.isEmpty || tfPass.text!.isEmpty || tfNumb.text!.isEmpty{
            let alertBox = UIAlertController(title: "ERROR!", message: "Fill Name and Password and Doctors # Field", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertBox.addAction(okAction)
            present(alertBox,animated: true)
        }
        else{
            let name = tfName.text!
            let pass = tfPass.text!
            let num = tfNumb.text!
            let avatar = avatarPic.titleForSegment(at: avatarPic.selectedSegmentIndex)
            let age = ageSlider.value
            //add info to user class object
            let user = RegisterData.init()
            user.initWithData(theName: name, thePass: pass, theAvatar: avatar!, theAge: Int(age), theNum: num)
            mainDelegate.users.append(user)
            //alert showing user was register
            let alertBox = UIAlertController(title: "Thank you!",
                                         message: "Name: "+name+" Pass: "+pass, preferredStyle: .alert)
            let homeAction = UIAlertAction(title: "HOME", style: .default) {//yes button
                (alert) in self.performSegue(withIdentifier: "unwindToHome", sender: self)
                self.dismiss(animated: true, completion: nil)
            }
            alertBox.addAction(homeAction)
            present(alertBox,animated: true)
        }
    }
    //textfield function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateAge()
    }
    

}
