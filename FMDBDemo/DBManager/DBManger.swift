//
//  DBManger.swift
//  FMDBDemo
//
//  Created by devang bhavsar on 20/08/20.
//  Copyright © 2020 devang bhavsar. All rights reserved.
//

import UIKit

class DBManager: NSObject {
    static let shared: DBManager = DBManager()
    let databaseFileName = "InterView.db"//"InterView.sqlite"
    var qautionid = "qautionid"
    var qaution = "Qaution"
    var ans = "ans"
    var givenanswer = "givenanswer"
    var optionId = "option_id"
    var quationSelectedId = "qaution_id"
    var option_id = "option_id"
    var selected = "selected"
    var option = "options"
    
    
    var pathToDatabaseofInterView: String = ""
    var pathToDatabaseQuationAns: String = ""
    var database: FMDatabase!
    var database2: FMDatabase!
    override init() {
        super.init()

        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabaseofInterView = documentsDirectory.appending("/\(databaseFileName)")
        print("Database path = \(pathToDatabaseofInterView)")
        copyDatabaseIfNeeded("InterView")
        
        let documentsDirectory2 = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
          pathToDatabaseQuationAns = documentsDirectory2.appending("/Quation_Option.db")
          print("Database pathAns = \(pathToDatabaseQuationAns)")
          copyDatabaseIfNeeded("Quation_Option")
        
    }
    
    func copyDatabaseIfNeeded(_ database: String) {

        let fileManager = FileManager.default

        let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)

        guard documentsUrl.count != 0 else {
            return
        }

        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("\(database).db")

        if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in documents folder")

            let databaseInMainBundleURL = Bundle.main.resourceURL?.appendingPathComponent("\(database).db")

            do {
                try fileManager.copyItem(atPath: (databaseInMainBundleURL?.path)!, toPath: finalDatabaseURL.path)
        
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }

        } else {
            print("Database file found at path: \(finalDatabaseURL.path)")
        }
    }
    
    
    
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabaseofInterView) {
                database = FMDatabase(path: pathToDatabaseofInterView)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    func openDatabase2() -> Bool {
           if database2 == nil {
               if FileManager.default.fileExists(atPath: pathToDatabaseQuationAns) {
                   database2 = FMDatabase(path: pathToDatabaseQuationAns)
               }
           }
           
           if database2 != nil {
               if database2.open() {
                   return true
               }
           }
           return false
       }
    
    func loadQuation() -> [quationsInfo]! {
        var quationList: [quationsInfo]!
        
        if openDatabase() {
            let query = "select * from InterView order by \(qautionid) asc"
            
            do {
                print(database!)
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {

                    let InterView = quationsInfo(quationId: Int(results.int(forColumn: qautionid)), quation: results.string(forColumn:qaution), ans: results.string(forColumn: ans), givenAns: Int(results.int(forColumn:givenanswer)))
                    
                    if quationList == nil {
                        quationList = [quationsInfo]()
                    }
                    
                    quationList.append(InterView)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return quationList
    }
    
    func updateQaution(withID ID: Int, givenanswer: Int) {
        if openDatabase() {
            let query = "update InterView set \(givenanswer)=? where \(qautionid)=?"
            
            do {
                try database.executeUpdate(query, values: [givenanswer,ID])
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
    }
    
    func loadOptions(quationId:Int) -> [AnswerOption] {
         var optionList: [AnswerOption]!
        if openDatabase2() {
                   let query = "select * from Quation_option where qaution_id = \(quationId)"
                   
                   do {
                       print(database2!)
                       let results = try database2.executeQuery(query, values: nil)
                       
                       while results.next() {

                        let InterView = AnswerOption(optionId: Int(results.int(forColumn: optionId)), quationId: Int(results.int(forColumn: quationSelectedId)), option: results.string(forColumn: option), selected:Int(results.int(forColumn: selected)))
                           
                           if optionList == nil {
                               optionList = [AnswerOption]()
                           }
                        
                           optionList.append(InterView)
                       }
                   }
                   catch {
                       print(error.localizedDescription)
                   }
                   
                   database2.close()
               }
        return optionList
    }
    
    
    func updateloadOptions(SelectedAns ans: Int, optionId: Int) {
        if openDatabase2() {
            let query = "update Quation_option set \(selected)=? where \(option_id)=?"
            
            do {
                try database2.executeUpdate(query, values: [ans,optionId])
            }
            catch {
                print(error.localizedDescription)
            }
            
            database2.close()
        }
    }
}
