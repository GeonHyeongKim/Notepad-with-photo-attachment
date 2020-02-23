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
        let createTableString = "CREATE TABLE IF NOT EXISTS note(Id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, lastDate TEXT, importance TEXT, background TEXT, text_size INTEGER, text_color TEXT);"
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
        let createTableString = "CREATE TABLE IF NOT EXISTS image(Id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, note_id INTEGER, photo TEXT, CONSTRAINT fk_attach FOREIGN KEY (note_id) REFERENCES note(id) ON DELETE CASCADE);"
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
    
    func insertNote(id: Int, title:String, content: String, lastDate: String, importance: UIColor, background: UIColor, text_size: Int, text_color: UIColor)
    {
        let notes = read()
        for note in notes
        {
            if note.id == id
            {
                return
            }
        }
        
        let insertStatementString = "INSERT INTO note (id, title, content, lastDate, importance, background, text_size, text_color) VALUES (?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
//            sqlite3_bind_int(insertStatement, 1, Int32(id)) --> 자동입력이라 무시가능
            sqlite3_bind_text(insertStatement, 2, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (content as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (lastDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (importance.toHex! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (background.toHex! as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 7, Int32(text_size))
            sqlite3_bind_text(insertStatement, 8, (text_color.toHex! as NSString).utf8String, -1, nil)

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
    
    func insertImage(id: Int, note_id: Int, photo: UIImage)
    {
        let insertStatementString = "INSERT INTO image (id, note_id, photo) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            //            sqlite3_bind_int(insertStatement, 1, Int32(id)) --> 자동입력이라 무시가능
            sqlite3_bind_int(insertStatement, 2, Int32(note_id))
            
            // encode
            let imageData:NSData = photo.pngData()! as NSData
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            
            sqlite3_bind_text(insertStatement, 3, (strBase64 as NSString).utf8String, -1, nil)
            
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
    
    // note
    func update(id: Int, title:String, content: String, lastDate: String, importance: UIColor, background: UIColor, text_size: Int, text_color: UIColor) {
        let updateStatementString = "UPDATE note SET title = '\(title)', content = '\(content)', lastDate = '\(lastDate)', importance = '\(String(describing: importance.toHex!))', background = '\(String(describing: background.toHex!))', text_size = '\(text_size)', text_color = '\(String(describing: text_color.toHex!))' WHERE id = '\(id)';"

        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    // note
    func read() -> [NoteModel] {
        let queryStatementString = "SELECT * FROM note ORDER BY id DESC;"
        var queryStatement: OpaquePointer? = nil
        var noteModels : [NoteModel] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let title = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let content = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let lastDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let importance = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let background = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let text_size = sqlite3_column_int(queryStatement, 6)
                let text_color = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))

                
                noteModels.append(NoteModel(id: Int(id), title: title, content: content, lastDate: lastDate, importance: UIColor.init(hexString: importance), background: UIColor.init(hexString: background), text_size: Int(text_size), text_color: UIColor.init(hexString: text_color)))
                
//                print("Query Result:")
                print("\(id) | \(title) | \(lastDate)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return noteModels
    }
    
    // note
    func readLast() -> NoteModel {
        let queryStatementString = "SELECT * FROM (SELECT * FROM note ORDER BY id DESC) LIMIT 1"
        var queryStatement: OpaquePointer? = nil
        var noteModels : [NoteModel] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let title = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let content = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let lastDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let importance = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let background = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let text_size = sqlite3_column_int(queryStatement, 6)
                let text_color = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                
                noteModels.append(NoteModel(id: Int(id), title: title, content: content, lastDate: lastDate, importance: UIColor.init(hexString: importance), background: UIColor.init(hexString: background), text_size: Int(text_size), text_color: UIColor.init(hexString: text_color)))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return noteModels.first!
    }
    
    // image
    func readFirstThumb(id: Int) -> ImageModel? {
        let queryStatementString = "SELECT * FROM image WHERE note_id = '\(id)' ORDER BY id ASC LIMIT 1"
        var queryStatement: OpaquePointer? = nil
        var imageModels : [ImageModel] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let note_id = sqlite3_column_int(queryStatement, 1)
                let photo = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))

                // Decode
                let dataDecoded:NSData = NSData(base64Encoded: photo, options: .ignoreUnknownCharacters)!

                imageModels.append(ImageModel(id: Int(id), note_id: Int(note_id), photo: UIImage(data: dataDecoded as Data)!))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return imageModels.first
    }
    
    func readThumb() -> [ImageModel] {
        let queryStatementString = "SELECT * FROM image"
        var queryStatement: OpaquePointer? = nil
        var imageModels : [ImageModel] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let note_id = sqlite3_column_int(queryStatement, 1)
                let photo = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))

                let dataDecoded:NSData = NSData(base64Encoded: photo, options: .ignoreUnknownCharacters)!

                imageModels.append(ImageModel(id: Int(id), note_id: Int(note_id), photo: UIImage(data: dataDecoded as Data)!))
                print("\(id) | \(note_id) ")

            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        return imageModels
    }
    
    // note
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
    
    // image
    func deleteImagesByID(note_id:Int) {
        let deleteStatementStirng = "DELETE FROM image WHERE note_id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(note_id))
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
