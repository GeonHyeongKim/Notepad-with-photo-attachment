//
//  DBHelper.swift
//  Notepad
//
//  Created by gunhyeong on 2020/02/21.
//  Copyright © 2020 geonhyeong. All rights reserved.
//

import UIKit
import SQLite3

var db:DBHelper = DBHelper()

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "myNoteDB.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        createNoteTable()
        createImageTable()
    }
    
    /// create note table
    func createNoteTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS note(Id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, lastDate TEXT, importance TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("note table created.")
            } else {
                print("note table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    /// create image table - 외래키로 note의 id 이며, on delete cascade 설정
    func createImageTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS image(Id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, note_id INTEGER, data TEXT, CONSTRAINT fk_attach FOREIGN KEY (note_id) REFERENCES note(id) ON DELETE CASCADE);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("image table created.")
            } else {
                print("image table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insertNote(id: Int, title:String, conetent: String, lastDate: String, importance: UIColor)
    {
        let notes = read()
        for note in notes
        {
            if note.id == id
            {
                return
            }
        }
        
        let insertStatementString = "INSERT INTO note (id, title, content, lastDate, importance) VALUES (?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
//            sqlite3_bind_int(insertStatement, 1, Int32(id)) --> 자동입력
            sqlite3_bind_text(insertStatement, 2, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (conetent as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (lastDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (importance.toHex! as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [NoteModel] {
        let queryStatementString = "SELECT * FROM note;"
        var queryStatement: OpaquePointer? = nil
        var noteModels : [NoteModel] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let title = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let content = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let lastDate = String(sqlite3_column_double(queryStatement, 3))
                let importance = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                noteModels.append(NoteModel(id: Int(id), title: title, conetent: content, lastDate: lastDate, importance: UIColor.init(hexString: importance)))
                print("Query Result:")
                print("\(id) | \(title)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return noteModels
    }
    
    
    
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM note WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}
