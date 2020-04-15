//
//  RegisterData.swift
//  MedixFinalProject
//
//  Created by Arashdeep
//  Copyright © 2020 Xcode User. All rights reserved.
//used for user data

import UIKit

class RegisterData: NSObject {

    var name: String = ""
    var pass: String = ""
    var avatar: String = ""
    var age: Int!
    var number: String = ""
    //add's variables to make user object
    func initWithData(theName N: String, thePass P: String, theAvatar a: String, theAge Ag: Int, theNum num: String){
        name = N
        pass = P
        avatar = a
        age = Ag
        number = num
    }
    
    
}
