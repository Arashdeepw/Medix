//
//  FormViewController.swift
//  Medix
//
//  Created by Gabby
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class FormViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var slQuantity : UISlider!
    @IBOutlet var lbQuantity : UILabel!
    @IBOutlet var datePicker : UIDatePicker!
    @IBOutlet var txtMedName : UITextField!
    @IBOutlet var firstAvatar: UIButton!
    @IBOutlet var secondAvatar: UIButton!
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    var avatarImage: String? = nil
    var selectedID: Int = 0
    
    // update quantity slider
    func updateLabel() {
        //Slide value
        let quantity = slQuantity.value
        // Convert to Int
        let strQuantity = String(format: "%i", Int(quantity))
        // Update label
        lbQuantity.text = strQuantity
    }
    
    // datepicker
    func dateOutput() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: datePicker.date)
    }
    
    
    @IBAction func slideValueChanged(sender: UISlider) {
        updateLabel()
    }
    
    @IBAction func updateData() {
        
    }
    
    @IBAction func insertData() {
        
    }
    
    
    @IBAction func insertMedication(sender: Any) {
        // validation
        if txtMedName.text == "" {
            // a. create alertbox
            let alertController = UIAlertController(title: "ERROR", message: "Please enter the name of your medication", preferredStyle: .alert)
            
            // b. create btn
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            // c. add btn to alertbox
            alertController.addAction(cancelAction)
            
            // d. present to screen
            present(alertController, animated: true)
        } else if avatarImage == nil {
            // a. create alertbox
            let alertController = UIAlertController(title: "ERROR", message: "Please select an avatar", preferredStyle: .alert)
            
            // b. create btn
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            // c. add btn to alertbox
            alertController.addAction(cancelAction)
            
            // d. present to screen
            present(alertController, animated: true)
            
        } else {
            // 1. create person obj with retrieved txt fields
            var returnMsg = ""
            let formData = FormData.init()
            formData.initWithFormData(theRow: selectedID, theUsername: txtMedName.text! , theMedName: txtMedName.text!, theMedQuantity: Int(lbQuantity.text!)!, theStartDate: dateOutput())
            
            
            // insert into DB
            //let returnCode = mainDelegate.insertIntoDatabase(person: person)
            
            //            if returnCode == false {
            //                returnMsg = "DB insert failed"
            //            } else {
            //                returnMsg = "Person was added"
            //                // reload the picker
            //           //     mainDelegate.readDataFromDatabase()
            //           //     thePicker.reloadAllComponents()
            //            }
            
            // create alertbox
            let alertController = UIAlertController(title: "SQLite Insert", message: returnMsg, preferredStyle: .alert)
            
            // b. create btn
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            // c. add btn to alertbox
            alertController.addAction(cancelAction)
            
            // d. present to screen
            present(alertController, animated: true)
        }
    }
    
    @IBAction func updateMedication(sender: Any) {
        // Validation
        if txtMedName.text == "" {
            // a. create alertbox
            let alertController = UIAlertController(title: "ERROR", message: "Please enter the name of your medication", preferredStyle: .alert)
            
            // b. create btn
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            // c. add btn to alertbox
            alertController.addAction(cancelAction)
            
            // d. present to screen
            present(alertController, animated: true)
        } else if avatarImage == nil {
            // a. create alertbox
            let alertController = UIAlertController(title: "ERROR", message: "Please select an avatar", preferredStyle: .alert)
            
            // b. create btn
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            // c. add btn to alertbox
            alertController.addAction(cancelAction)
            
            // d. present to screen
            present(alertController, animated: true)
            
        } else {
            // 1. create person obj with retrieved txt fields
            var returnMsg = ""
            let formData = FormData.init()
            formData.initWithFormData(theRow: selectedID, theUsername: txtMedName.text! , theMedName: txtMedName.text!, theMedQuantity: Int(lbQuantity.text!)!, theStartDate: dateOutput())
            
            
            // update in DB
            //let returnCode = mainDelegate.insertIntoDatabase(person: person)
            
            //            if returnCode == false {
            //                returnMsg = "DB insert failed"
            //            } else {
            //                returnMsg = "Person was added"
            //                // reload the picker
            //                //     mainDelegate.readDataFromDatabase()
            //                //     thePicker.reloadAllComponents()
            //            }
            
            // create alertbox
            let alertController = UIAlertController(title: "SQLite Insert", message: returnMsg, preferredStyle: .alert)
            
            // b. create btn
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            // c. add btn to alertbox
            alertController.addAction(cancelAction)
            
            // d. present to screen
            present(alertController, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        updateLabel()
        
    }
    
    // hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
