//
//  TableViewController.swift
//  MedixFinalProject
//
//  Created by Arashdeep
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.meds.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SiteCell ?? SiteCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        let rowNum = indexPath.row
        let avatar = mainDelegate.meds[rowNum].avatar
        
        //let avatar = mainDelegate.users[mainDelegate.userIndex!].avatar
        
        tableCell.primaryLabel.text = mainDelegate.meds[rowNum].username
        tableCell.secondaryLabel.text = "Medication: "+mainDelegate.meds[rowNum].medname!
        if avatar == "Male"{
            tableCell.myImageView.image = UIImage(named: "raptors.jpg")
        }
        if avatar == "Female"{
            tableCell.myImageView.image = UIImage(named: "leafs.png")
        }
        
        tableCell.accessoryType = .disclosureIndicator
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let rownum = indexPath.row
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) in
            print("Delete button tapped")
             let num = self.mainDelegate.meds[indexPath.row].ID
             print(num)
            let returnCode = self.mainDelegate.deleteDataFromDatabase(medID: num!)
             var returnMSG : String = "Person Deleted"
             if returnCode == false{
                 returnMSG = "Person not Deleted"
             }
             let alertBox = UIAlertController(title: "Thank you!", message: returnMSG, preferredStyle: .alert)
             let okAction = UIAlertAction(title: "OK", style: .default){(alert) in
                 self.dismiss(animated: true, completion: nil)
             }
             alertBox.addAction(okAction)
            self.present(alertBox,animated: true)
            
        }
        delete.backgroundColor = .red
        
        return [delete]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainDelegate.readDataFromDatabase()
        // Do any additional setup after loading the view.
    }
    


}
