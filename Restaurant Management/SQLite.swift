//
//  SQLite.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/17/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import Foundation
// MARK: ***SQLite3

var database:OpaquePointer?
//Database pointer
func Connect_DB_SQLite( dbName:String, type:String)->OpaquePointer{
    var database:OpaquePointer? = nil
    var dbPath:String = ""
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
    let storePath : NSString = documentsPath.appendingPathComponent(dbName) as NSString
    let fileManager : FileManager = FileManager.default
    dbPath = Bundle.main.path(forResource: dbName , ofType:type)!
    do {
        try fileManager.copyItem(atPath: dbPath, toPath: storePath as String)
    } catch {
        
    }
    let result = sqlite3_open(dbPath, &database)
    if result != SQLITE_OK {
        sqlite3_close(database)
        print("Failed to open database")
    }
    return database!
}
func createTable(query: String) {
    var statement : OpaquePointer?
    if sqlite3_prepare_v2(database, query,-1, &statement, nil) == SQLITE_OK{
        if sqlite3_step(statement) == SQLITE_DONE{
            print("Table created!")
        }else{
            let errmsg = String(cString: sqlite3_errmsg(database))
            print(errmsg)
        }
    }else{
        let errmsg = String(cString: sqlite3_errmsg(database))
        print(errmsg)
    }
}
func edit(query: String)-> Bool{
    var result:Bool = false
    var insertStatement : OpaquePointer? = nil
    if sqlite3_prepare_v2(database, query, -1, &insertStatement, nil) == SQLITE_OK{
        if sqlite3_step(insertStatement) == SQLITE_DONE{
            result = true
        }else{
            result = false
        }
    }else{
        print("Edit statement could not be prepared.")
        result = false
    }
    sqlite3_finalize(insertStatement)
    return result
}

//func insert_row(stu: Studentx) -> Bool {
//    let bd: String = dateFormatter.string(from: stu.m_birthday)
//    let query = "INSERT INTO Student(mssv,firstName,lastName,classID,birthday,otherInfo) VALUES (\(stu.m_mssv!),'\(stu.m_fName!)','\(stu.m_lName!)','\(stu.m_classID!)','\(bd)','\(stu.m_otherInfo!)')"
//    return edit(query: query)
//}
//func delete_row(stu: Studentx) -> Bool {
//    let query = "DELETE FROM Student WHERE mssv = \(stu.m_mssv!)"
//    return edit(query: query)
//}
//func update_row(stu: Studentx) -> Bool {
//    let bd = dateFormatter.string(from: stu.m_birthday)
//    let query = "UPDATE Student SET firstName = '\(stu.m_fName!)', lastName = '\(stu.m_lName!)', classID = '\(stu.m_classID!)', birthday = '\(bd)', otherInfo = '\(stu.m_otherInfo!)' WHERE mssv = \(stu.m_mssv!)"
//    return edit(query: query)
//}

//func GetdataFromSQLite(query: String) -> [Studentx]{
//    var Studentsx = [Studentx]()
//    var queryStatement:OpaquePointer? = nil
//    if sqlite3_prepare_v2(database, query, -1, &queryStatement, nil) == SQLITE_OK{
//        while sqlite3_step(queryStatement) == SQLITE_ROW{
//            let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
//            let queryResultCol2 = sqlite3_column_text(queryStatement, 2)
//            let queryResultCol3 = sqlite3_column_text(queryStatement, 3)
//            let queryResultCol4 = sqlite3_column_text(queryStatement,4)
//            let queryResultCol5 = sqlite3_column_text(queryStatement,5)
//            let mssv = Int(sqlite3_column_int(queryStatement, 0))
//            let fname = String(cString: queryResultCol1!)
//            let lname = String(cString: queryResultCol2!)
//            let classID = String(cString: queryResultCol3!)
//            let birthday = String(cString: queryResultCol4!)
//            let otherInfo = String(cString: queryResultCol5!)
//            let stu = Studentx(mssv: mssv, firstName: fname,lastName: lname,classID: classID,birthday: birthday,otherInfo: otherInfo)
//            Studentsx.append(stu)
//            if MSSV_last <= mssv{
//                MSSV_last = mssv
//            }
//            //print("Query result: \(mssv): \(fname) \(lname) - \(classID) - \(birthday) - \(otherInfo)")
//            
//        }
//    }
//    if Studentsx.count != 0{
//        MSSV_last = Studentsx[Studentsx.count - 1].m_mssv
//    }
//    return Studentsx
//}
//func updateData() {
//    Studentsx.removeAll()
//    Studentsx = GetdataFromSQLite(query: "SELECT* FROM Student")
//    print("Data updated")
//}