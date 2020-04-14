//
//  AppDelegate.swift
//  MedixFinalProject
//
//  Created by Arashdeep
//  Copyright © 2020 Xcode User. All rights reserved.
//used for user and med data, and database

import UIKit
import SQLite3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var users : [RegisterData] = []
    var userIndex : Int?
    
    var databaseName : String? = "FinalProjectDB.db"
    var databasePath : String?
    var meds : [FormData] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir = documentPaths[0]
        databasePath = documentsDir.appending("/"+databaseName!)
        checkAndCreateDatabase()
        readDataFromDatabase()
        
        return true
    }
    // Creates the db
    func checkAndCreateDatabase() {
        var success = false
        let fileManager = FileManager.default
        success = fileManager.fileExists(atPath: databasePath!)
        if success {
            return
        }
        // path of DB
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        // copy/paste into documents folder, try? for errors
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
        return
    }
    // reads from the medication db
    func readDataFromDatabase() {
        // empty the medication array
        meds.removeAll()
        // c pointer that points to DB object
        var db : OpaquePointer? = nil
        // open connection to db
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
             // success msg
            print("Opened connected to database at \(String(describing: self.databasePath))")
            // set up the query statement
            var queryStatement : OpaquePointer? = nil
            // select query string
            let queryStatementString : String = "select * from medication"
            // prepare statement
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil)  == SQLITE_OK {
                // fetch db data
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    // extract rows - retrieved as c-strings for strings
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cname = sqlite3_column_text(queryStatement, 1)
                    let cmedName = sqlite3_column_text(queryStatement, 2)
                    let medQuantity: Int = Int(sqlite3_column_int(queryStatement, 3))
                    let cstartdate = sqlite3_column_text(queryStatement, 4)
                    let cavatar = sqlite3_column_text(queryStatement, 5)
                    let medDosage : Int = Int(sqlite3_column_int(queryStatement, 6))
                    let cmedDetails = sqlite3_column_text(queryStatement, 7)
                    
                    // convert from cstring to regular strings
                    let name = String(cString: cname!)
                    let medName = String(cString: cmedName!)
                    let startDate = String(cString: cstartdate!)
                    let avatar = String(cString: cavatar!)
                    let medDetails = String(cString: cmedDetails!)
                    
                    // embed inside form data object (FormData class)
                    let data = FormData.init()
                    data.initWithFormData(theRow: id, theUsername: name, theMedName: medName, theMedQuantity: medQuantity, theStartDate: startDate, theAvatar: avatar, theMedDosage: medDosage, theMedDetails: medDetails)
                    // append to the medication array
                    meds.append(data)
                    
                    // verification
                    print("\(id) | \(name) | \(medName) | \(medQuantity) | \(startDate) | \(avatar) | \(medDosage) | \(medDetails)")
                    
                }
                // free memory that was allocated - cleanup
                sqlite3_finalize(queryStatement)
            }
            else {
                print("Select statement could not be prepared")
            }
            // close connection to db
            sqlite3_close(db)
        }
        else{
            print("Unable to open DB")
        }
    }
    
    // insert new row into DB
    func insertIntoDatabase (med : FormData) -> Bool {
         // c pointer that points to DB object
        var db : OpaquePointer? = nil
        // success msg of insert operation
        var returnCode : Bool = true
        // open the connection
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            // set up insert statement
            var insertStatement : OpaquePointer? = nil
            // insert query string
            let insertStatementString : String = "Insert into medication values(NULL,?,?,?,?,?, ?, ?)"
            // prepare statement
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                // convert from cstring to regular strings
                let nameStr = med.username! as NSString
                let medNameStr = med.medname! as NSString
                let quantity = med.medquantity
                let startDateStr = med.startdate! as NSString
                let avatarStr = med.avatar! as NSString
                let medDosage = med.meddosage
                let medDetailsStr = med.meddetails! as NSString
                
                // bind to query
                sqlite3_bind_text(insertStatement, 1, nameStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, medNameStr.utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 3, Int32(quantity!))
                sqlite3_bind_text(insertStatement, 4, startDateStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 5, avatarStr.utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 6, Int32(medDosage!))
                sqlite3_bind_text(insertStatement, 7, medDetailsStr.utf8String, -1, nil)
                
                // perform DB insertion
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    // retrieve ID of inserted row
                    let rowID = sqlite3_last_insert_rowid(db)
                    // verification
                    print("Succcesully inserted row \(rowID)")
                }
                else{
                    print("Could not insert row")
                    returnCode = false
                }
                // free memory that was allocated - cleanup
                sqlite3_finalize(insertStatement)
            }
            else{
                print("Insert statement could not be prepared")
                returnCode = false
            }
            // close DB connection
            sqlite3_close(db)
        }
        else {
            print("Unable to open database")
            returnCode = false
        }
        
        return returnCode
    }
    
    // update row from DB
    func updateDataFromDatabase (med : FormData) -> Bool {
        // c pointer that points to DB object
        var db : OpaquePointer? = nil
        // success msg of update opertation
        var returnCode : Bool = true
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            // set up update statement
            var updateStatement : OpaquePointer? = nil
            // update query string
            let updateStatementString : String = "Update medication set MedicationName = ?, MedicationQuantity = ?, StartDate = ?, MedicationDosage = ?, MedicationDetails = ? where ID = ?"
            // prepare statement
            if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                // convert from cstring to regular strings
                let id = med.ID
                let medNameStr = med.medname! as NSString
                let quantity = med.medquantity
                let startDateStr = med.startdate! as NSString
                let medDosage = med.meddosage
                let medDetailsStr = med.meddetails! as NSString
                
                // bind to query
                sqlite3_bind_text(updateStatement, 1, medNameStr.utf8String, -1, nil)
                sqlite3_bind_int(updateStatement, 2, Int32(quantity!))
                sqlite3_bind_text(updateStatement, 3, startDateStr.utf8String, -1, nil)
                sqlite3_bind_int(updateStatement, 4, Int32(medDosage!))
                sqlite3_bind_text(updateStatement, 5, medDetailsStr.utf8String, -1, nil)
                sqlite3_bind_int(updateStatement, 6, Int32(id!))
                
                // perform update
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    // verfication
                    print("Succcesully Updated row")
                }
                else{
                    print("Could not update row")
                    returnCode = false
                }
                // free memory that was allocated - cleanup
                sqlite3_finalize(updateStatement)
            }
            else{
                print("update statement could not be prepared")
                returnCode = false
            }
            // close DB connection
            sqlite3_close(db)
        }
        else {
            print("Unable to open database")
            returnCode = false
        }
        
        return returnCode
    }
    
    // delete row from DB
    func deleteDataFromDatabase (medID: Int) -> Bool {
        // c pointer that points to DB object
        var db : OpaquePointer? = nil
        // success msg from delete operation
        var returnCode : Bool = true
        // open connection to DB
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            // set up delete statement
            var deleteStatement : OpaquePointer? = nil
            // delete query
            let deleteStatementString : String = "Delete from medication where ID = ?"
            // prepare statement
            if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
                // bind to query
                sqlite3_bind_int(deleteStatement, 1, Int32(medID))
                // perform deletion
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    // verification
                    print("Succcesully Deleted row")
                } else {
                    print("Could not delete row")
                    returnCode = false
                }
                // free memory that was allocated - cleanup
                sqlite3_finalize(deleteStatement)
            }
            else{
                print("delete statement could not be prepared")
                returnCode = false
            }
             // close DB connection
            sqlite3_close(db)
        } else {
            print("Unable to open database")
            returnCode = false
        }
    
        return returnCode
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

