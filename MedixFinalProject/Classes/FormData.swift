//
//  FormData.swift
//  Medix
//
//  Created by Gabby
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class FormData: NSObject {
    
    var ID: Int?
    var username: String?
    var medname: String?
    var medquantity: Int?
    var startdate: String?
    var avatar: String?
    var meddosage: Int?
    var meddetails: String?
    
    func initWithFormData(theRow id: Int, theUsername userName: String, theMedName medName: String, theMedQuantity medQuantity: Int, theStartDate startDate: String, theAvatar Avatar: String, theMedDosage medDosage: Int, theMedDetails medDetails: String) {
        ID = id;
        username = userName;
        medname = medName;
        medquantity = medQuantity;
        startdate = startDate;
        avatar = Avatar;
        meddosage = medDosage;
        meddetails = medDetails;
    }
}
