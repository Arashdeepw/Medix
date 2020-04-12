//
//  AppDelegate.swift
//  MedixFinalProject
//
//  Created by Arashdeep
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit
import SQLite3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var users : [RegisterData] = []
    var userIndex : Int?
    
    var databaseName : String? = "MedixDB.db"
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
    func readDataFromDatabase(){
        meds.removeAll()
        var db : OpaquePointer? = nil
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK{
            print("Opened connected to database at \(self.databasePath)")
            var queryStatement : OpaquePointer? = nil
            var queryStatementString : String = "select * from entries"
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil)  == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW{
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cname = sqlite3_column_text(queryStatement, 1)
                    let cmedName = sqlite3_column_text(queryStatement, 2)
                    let medQuantity: Int = Int(sqlite3_column_int(queryStatement, 3))
                    let cdate = sqlite3_column_text(queryStatement, 4)
                    let cavatar = sqlite3_column_text(queryStatement, 5)
    
                    let name = String(cString: cname!)
                    let medName = String(cString: cmedName!)
                    let date = String(cString: cdate!)
                    let avatar = String(cString: cavatar!)
    
                    let data = FormData.init()
                    data.initWithFormData(theRow: id, theUsername: name, theMedName: medName, theMedQuantity: medQuantity, theStartDate: date, theAvatar: avatar)
                    meds.append(data)
                }
                sqlite3_finalize(queryStatement)
            }
            else {
                    print("Select statement could not be prepared")
                }
                sqlite3_close(db)
            }
            else{
                print("Unable to open DB")
            }
        }
        func insertIntoDatabase(med : FormData)->Bool{
            var db : OpaquePointer? = nil
            var returnCode : Bool = true
            if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
                var insertStatement : OpaquePointer? = nil
                var insertStatementString : String = "Insert into entries values(NULL,?,?,?,?,?)"
                if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK{
                    let nameStr = med.username! as NSString
                    let medNameStr = med.medname! as NSString
                    let quantity = med.medquantity
                    let startDateStr = med.startdate! as NSString
                    let avatarStr = med.avatar! as NSString
  
                    sqlite3_bind_text(insertStatement, 1, nameStr.utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 2, medNameStr.utf8String, -1, nil)
                    sqlite3_bind_int(insertStatement, 3, Int32(quantity!))
                    sqlite3_bind_text(insertStatement, 4, startDateStr.utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 5, avatarStr.utf8String, -1, nil)
    
                    if sqlite3_step(insertStatement)==SQLITE_DONE{
                        let rowID = sqlite3_last_insert_rowid(db)
                        print("Succcesully inserted row \(rowID)")
                    }
                    else{
                        print("Could not insert row")
                        returnCode = false
                    }
                    sqlite3_finalize(insertStatement)
                }
                else{
                    print("Insert statement could not be prepared")
                    returnCode = false
                }
                sqlite3_close(db)
            }
            else {
                print("Unable to open database")
                returnCode = false
            }
    
            return returnCode
        }
    
        func updateDataFromDatabase(med: FormData)-> Bool{
            var db : OpaquePointer? = nil
            var returnCode : Bool = true
            if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
                var updateStatement : OpaquePointer? = nil
                var updateStatementString : String = "Update entries set MedName = ?, MedQuantity = ?, StartDate = ? where ID = ?"
                if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK{
                    let id = med.ID
                    let medNameStr = med.medname! as NSString
                    let quantity = med.medquantity
                    let startDateStr = med.startdate! as NSString
    
                    sqlite3_bind_text(updateStatement, 1, medNameStr.utf8String, -1, nil)
                    sqlite3_bind_int(updateStatement, 2, Int32(quantity!))
                    sqlite3_bind_text(updateStatement, 3, startDateStr.utf8String, -1, nil)
                    sqlite3_bind_int(updateStatement, 4, Int32(id!))
    
                    if sqlite3_step(updateStatement)==SQLITE_DONE{
                        print("Succcesully Updated row")
                    }
                    else{
                        print("Could not update row")
                        returnCode = false
                    }
                    sqlite3_finalize(updateStatement)
                }
                else{
                    print("update statement could not be prepared")
                    returnCode = false
                }
                sqlite3_close(db)
            }
            else {
                print("Unable to open database")
                returnCode = false
            }
    
            return returnCode
        }
    
        func deleteDataFromDatabase(medID: Int)-> Bool{
            var db : OpaquePointer? = nil
            var returnCode : Bool = true
            if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
                var deleteStatement : OpaquePointer? = nil
                var deleteStatementString : String = "Delete from entries where ID = ?"
                if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK{
    
                    sqlite3_bind_int(deleteStatement, 1, Int32(medID))
    
                    if sqlite3_step(deleteStatement)==SQLITE_DONE{
                        print("Succcesully Deleted row")
                    }
                    else{
                        print("Could not delete row")
                        returnCode = false
                    }
                    sqlite3_finalize(deleteStatement)
                }
                else{
                    print("delete statement could not be prepared")
                    returnCode = false
                }
                sqlite3_close(db)
            }
            else {
                print("Unable to open database")
                returnCode = false
            }
    
            return returnCode
        }
    
        func checkAndCreateDatabase(){
            var success = false
            let fileManager = FileManager.default
    
            success = fileManager.fileExists(atPath: databasePath!)
            if success{
                return
            }
            let databasePathFromApp = Bundle.main.resourcePath?.appending("/"+databaseName!)
            try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
            return
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

