//
//  FormViewController.swift
//  Medix
//
//  Created by Gabby
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit
import EventKit

class FormViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    // picker view of medication name
    @IBOutlet var thePicker : UIPickerView!
    // medication name
    @IBOutlet var txtMedName : UITextField!
    // medication quantity
    @IBOutlet var slQuantity : UISlider!
    @IBOutlet var lbQuantity : UILabel!
    // medication dosage
    @IBOutlet var slDosage : UISlider!
    @IBOutlet var lbDosage : UILabel!
    // medication details
    @IBOutlet var txtMedDetails : UITextField!
    // picker for start date
    @IBOutlet var datePicker : UIDatePicker!
    // btns
    @IBOutlet var btnInsert : UIButton!
    @IBOutlet var btnUpdate : UIButton!
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    let eventStore = EKEventStore()
    var selectedID: Int = 0
    
    
    // hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    // update quantity /dosage slider
    func updateQuantityLabel() {
        //Slider value
        let quantity = slQuantity.value
        // Convert to Int
        let strQuantity = String(format: "%i", Int(quantity))
        // Update label
        lbQuantity.text = strQuantity
    }
    
    @IBAction func quantityValueChanged(sender: UISlider) {
        updateQuantityLabel()
    }
    
    // update dosage slider
    func updateDosageLabel() {
        //Slider value
        let dosage = slDosage.value
        // Convert to Int
        let strDosage = String(format: "%i", Int(dosage))
        // Update label
        lbDosage.text = strDosage
    }
    
    @IBAction func dosageValueChanged(sender: UISlider) {
        updateDosageLabel()
    }
    
    // datepicker formatter
    func dateOutput() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: datePicker.date)
    }
    
    // pickerview functions
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Arial", size: 30)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = mainDelegate.meds[row].medname
        pickerLabel?.textColor = UIColor.white
        
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
        // format start date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: mainDelegate.meds[row].startdate!)
        
        txtMedName.text = mainDelegate.meds[row].medname
        slQuantity.value = Float(mainDelegate.meds[row].medquantity!)
        lbQuantity.text = String(mainDelegate.meds[row].medquantity!)
        slDosage.value = Float(mainDelegate.meds[row].meddosage!)
        lbDosage.text = String(mainDelegate.meds[row].meddosage!)
        txtMedDetails.text = mainDelegate.meds[row].meddetails
        datePicker.date = date!
        selectedID = mainDelegate.meds[row].ID!
    }
    
    // insert new medication into DB
    @IBAction func insertMedication(sender: Any) {
        // validation
        if txtMedName.text == ""  || txtMedDetails.text == "" {
            // a. create alertbox
            let alertController = UIAlertController(title: "ERROR", message: "All fields are required", preferredStyle: .alert)
            
            // b. create btn
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            // c. add btn to alertbox
            alertController.addAction(cancelAction)
            
            // d. present to screen
            present(alertController, animated: true)
        } else {
            // retreieve username and avatar from main delete
            let avatar = mainDelegate.users[mainDelegate.userIndex!].avatar
            let userName = mainDelegate.users[mainDelegate.userIndex!].name
            // success msg for insertion
            var returnMsg = ""
            
            // initialize form data object with UI fields
            let formData = FormData.init()
            formData.initWithFormData(theRow: selectedID, theUsername: userName, theMedName: txtMedName.text!, theMedQuantity: Int(lbQuantity.text!)!, theStartDate: dateOutput(), theAvatar: avatar, theMedDosage: Int(lbDosage.text!)!, theMedDetails: txtMedDetails.text!)
            
            // insert into DB
            let returnCode = mainDelegate.insertIntoDatabase(med: formData)
            
            if returnCode == false {
                returnMsg = "DB insert failed"
            } else {
                returnMsg = "Medication was added to your calendar"
                // reload the picker
                mainDelegate.readDataFromDatabase()
                thePicker.reloadAllComponents()
            }
            
            // Fire the calendar event
            // calculate end date
            let startDate = datePicker.date
            var dateComponent = DateComponents()
            dateComponent.day = Int(lbQuantity.text!)
            let endDate = Calendar.current.date(byAdding: dateComponent, to: startDate)
            
            // fire caldendar event
            addEventToCalendar(title: txtMedName.text!, description: txtMedDetails.text!, startDate: startDate, endDate: endDate!)

            // create alertbox
            let alertController = UIAlertController(title: "SQLite Insert", message: returnMsg, preferredStyle: .alert)

            // create btn
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)

            // add btn to alertbox
            alertController.addAction(cancelAction)

            // present to screen
            present(alertController, animated: true)
        }
    }
    
    // update medication in DB
    @IBAction func updateMedication(sender: Any) {
        // Validation
        if txtMedName.text == "" || txtMedDetails.text == "" {
            // create alertbox
            let alertController = UIAlertController(title: "ERROR", message: "All fields are required", preferredStyle: .alert)
            
            // create btn
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            // add btn to alertbox
            alertController.addAction(cancelAction)
            
            // present to screen
            present(alertController, animated: true)
        } else {
            // retrieve username and avatar from main delegate
            let avatar = mainDelegate.users[mainDelegate.userIndex!].avatar
            let userName = mainDelegate.users[mainDelegate.userIndex!].name
            // success msg for update operation
            var returnMsg = ""
            
            // initialize form data object with retrieved UI fields
            let formData = FormData.init()
            formData.initWithFormData(theRow: selectedID, theUsername: userName, theMedName: txtMedName.text!, theMedQuantity: Int(lbQuantity.text!)!, theStartDate: dateOutput(), theAvatar: avatar, theMedDosage: Int(lbDosage.text!)!, theMedDetails: txtMedDetails.text!)
            
            // update in DB
            let returnCode = mainDelegate.updateDataFromDatabase(med: formData)
            
            if returnCode == false {
                returnMsg = "DB update failed"
            } else {
                returnMsg = "Medication was updated"
                // reload the picker
                mainDelegate.readDataFromDatabase()
                thePicker.reloadAllComponents()
                
            }
            // create alertbox
            let alertController = UIAlertController(title: "SQLite Update", message: returnMsg, preferredStyle: .alert)
            
            // create btn
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            // add btn to alertbox
            alertController.addAction(cancelAction)
            
            // present to screen
            present(alertController, animated: true)
        }
    }
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // btn styling
        btnInsert.layer.cornerRadius = 10
        btnInsert.clipsToBounds = true
        btnUpdate.layer.cornerRadius = 10
        btnUpdate.clipsToBounds = true
        
        // datepicker alterations
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.setValue(false, forKey: "highlightsToday")
        
        // update quantity label
        updateQuantityLabel()
        
        // update dosage label
        updateDosageLabel()
        
        // refresh db
        mainDelegate.readDataFromDatabase()
    }
}
