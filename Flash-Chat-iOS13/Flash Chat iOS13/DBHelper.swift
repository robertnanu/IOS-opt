//
//  DBHelper.swift
//  Flash Chat iOS13
//
//  Created by Nanu Robert on 01.05.2022.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper {
    var db : OpaquePointer?
    var path : String = "myDB.sqlite"
    init() {
        self.db = createDB()
        self.createTable()
    }
    
    func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:  nil, create: false).appendingPathExtension(path)
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("There is error in creating DB")
            return nil
        }else {
            print("Database has been created with path \(path)")
            return db
        }
    }
    
    func createTable() {
        let query = "CREATE TABLE IF NOT EXISTS grade(id INTEGER PRIMARY KEY AUTOINCREMENT,sender TEXT, body TEXT);"
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Table creation success")
            }else {
                print("Table creation fail")
            }
        } else {
            print("preparation fail")
        }
    }
    
    func insert(sender : String, body : String) {
        let query = "INSERT INTO grade (id, sender, body) VALUES (?, ?, ?)"
        
        var statement : OpaquePointer? = nil
        
        var isEmpty = false
        if read(sender: sender).isEmpty {
            isEmpty = true
        }
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            if isEmpty {
                sqlite3_bind_int(statement, 1, 1)
            }
            sqlite3_bind_text(statement, 2, (sender as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (body as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data inserted with success in myDB.sqlite")
            }else {
                print("Data is not inserted in table")
            }
        } else {
            print("Query is not as per requirement")
        }
    }

    func read(sender : String) -> [dbMessages] {
        var mainList = [dbMessages]()
        
        let query = "SELECT * FROM grade;"
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let sender = String(describing: sqlite3_column_text(statement, 1))
                let body = String(describing: sqlite3_column_text(statement, 2))
                let model = dbMessages()
                model.id = id
                model.sender = sender
                model.body = body
                
                mainList.append(model)
            }
        }
        return mainList
    }
}
