//
//  RegisterData.swift
//  MedixFinalProject
//
//  Created by Xcode User on 2020-04-12.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class RegisterData: NSObject {

    var name: String = ""
    var pass: String = ""
    var avatar: String = ""
    var age: Int!
    
    func initWithData(theName N: String, thePass P: String, theAvatar a: String, theAge Ag: Int){
        name = N
        pass = P
        avatar = a
        age = Ag
    }
    
    
}
