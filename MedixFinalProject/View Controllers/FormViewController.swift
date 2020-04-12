//
//  FormViewController.swift
//  Medix
//
//  Created by Gabby
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class FormViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var slQuantity : UISlider!
    @IBOutlet var lbQuantity : UILabel!
    @IBOutlet var thePicker : UIPickerView!
    @IBOutlet var datePicker : UIDatePicker!
    @IBOutlet var txtMedName : UITextField!
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
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
    func dateOutput() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: datePicker.date)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Avenir", size: 30)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = mainDelegate.meds[row].medname
        pickerLabel?.textColor = UIColor.black
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mainDelegate.meds.count
    }
    
    // returns how many columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: mainDelegate.meds[row].startdate!)
        
        txtMedName.text = mainDelegate.meds[row].medname
        lbQuantity.text = String(mainDelegate.meds[row].medquantity!)
        datePicker.date = date!
        selectedID = mainDelegate.meds[row].ID!
    }
    
    
    @IBAction func slideValueChanged(sender: UISlider) {
        updateLabel()
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
        } else {
            // create form data obj with retrieved txt fields
            let avatar = mainDelegate.users[mainDelegate.userIndex!].avatar
            let userName = mainDelegate.users[mainDelegate.userIndex!].name
            
            var returnMsg = ""
            let formData = FormData.init()
            formData.initWithFormData(theRow: selectedID, theUsername: userName, theMedName: txtMedName.text!, theMedQuantity: Int(lbQuantity.text!)!, theStartDate: dateOutput(), theAvatar: avatar)
            
            // insert into DB
            let returnCode = mainDelegate.insertIntoDatabase(med: formData)
            
            if returnCode == false {
                returnMsg = "DB insert failed"
            } else {
                // reload the picker
                mainDelegate.readDataFromDatabase()
                thePicker.reloadAllComponents()
            }

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
        } else {
            // create form data obj with retrieved UI fields
            let avatar = mainDelegate.users[mainDelegate.userIndex!].avatar
            let userName = mainDelegate.users[mainDelegate.userIndex!].name
            
            var returnMsg = ""
            let formData = FormData.init()
            formData.initWithFormData(theRow: selectedID, theUsername: userName, theMedName: txtMedName.text!, theMedQuantity: Int(lbQuantity.text!)!, theStartDate: dateOutput(), theAvatar: avatar)
            
            
            // update in DB
            let returnCode = mainDelegate.insertIntoDatabase(med: formData)
            
            if returnCode == false {
                returnMsg = "DB update failed"
            } else {
                returnMsg = "Data was updated"
                // reload the picker
                mainDelegate.readDataFromDatabase()
                thePicker.reloadAllComponents()
            }
            
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
        
        // update slider label
        updateLabel()
        
        // refresh db
        mainDelegate.readDataFromDatabase()
    }
    
    // hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
