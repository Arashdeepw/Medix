//
//  TableViewController.swift
//  MedixFinalProject
//
//  Created by Arashdeep
//  Copyright © 2020 Xcode User. All rights reserved.
//view to see and delete medication. Can send a text msg to the doctor incase out of meds

import UIKit
import MessageUI

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate  {
    //app delegate variable
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.meds.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //sets up tables
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SiteCell ?? SiteCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        let rowNum = indexPath.row
        let avatar = mainDelegate.meds[rowNum].avatar
        
        tableCell.primaryLabel.text = mainDelegate.meds[rowNum].medname
        tableCell.secondaryLabel.text = "Quantity: "+String(mainDelegate.meds[rowNum].medquantity!)
        //sets avatar
        if avatar == "Male" {
            tableCell.myImageView.image = UIImage(named: "male.png")
        }
        if avatar == "Female" {
            tableCell.myImageView.image = UIImage(named: "female.png")
        }
        tableCell.accessoryType = .disclosureIndicator
        return tableCell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //used to create delete button and command to delete meds from table
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) in
            print("Delete button tapped")
            let num = self.mainDelegate.meds[indexPath.row].ID
             //print(num)
            let returnCode = self.mainDelegate.deleteDataFromDatabase(medID: num!)
            var returnMSG : String = "Person Deleted"
            if returnCode == false{
                returnMSG = "Person not Deleted"
            }
            //alert to let user know item was removed
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowNum = indexPath.row
        //alert to show additional information
        let alertController = UIAlertController(title: mainDelegate.meds[rowNum].medname, message: "Start Date: "+mainDelegate.meds[rowNum].startdate!+"\nDescription: "+mainDelegate.meds[rowNum].meddetails!, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainDelegate.readDataFromDatabase()
        // Do any additional setup after loading the view.
    }
    //text msg app to text doctor
    @IBAction func sendText(sender: UIButton){
        //if textmsg app does not exist, then it will ignore action
        guard MFMessageComposeViewController.canSendText() else {return}
        let controller = MFMessageComposeViewController()
        controller.body = "Medication Refill Needed"
        controller.recipients = [mainDelegate.users[mainDelegate.userIndex!].number]
        controller.messageComposeDelegate = self
        self.present(controller, animated: true, completion: nil)
    }
    //when text msg is sent, prints a return msg and returns back app
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("MSG CANCELED")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("MSG FAILED")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("MSG SENT")
            self.dismiss(animated: true, completion: nil)
        default:
            break;
        }
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }


}
