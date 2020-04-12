//
//  FormViewController.swift
//  MedixFinalProject
//
//  Created by Gabby
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {
    
    @IBOutlet var slQuantity : UISlider!
    @IBOutlet var lbAge : UILabel!
    @IBOutlet var datePicker : UIDatePicker!
    
    // update quantity slider
    func updateLabel() {
        //Slide value
        let age = slQuantity.value
        // Convert to Int
        let strAge = String(format: "%i", Int(age))
        // Update label
        lbAge.text = strAge
    }
    
    @IBAction func slideValueChanged(sender: UISlider) {
        updateLabel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateLabel()
    }
    

}
