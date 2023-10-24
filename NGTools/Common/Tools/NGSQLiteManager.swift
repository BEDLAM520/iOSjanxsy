//
//  NGSQLiteManager.swift
//

import Foundation
//import FMDB

class NGSQLiteManager {
    
    
    struct SqlBadPointParam {
        var thresh = 50.0
        var maxval = 255.0
        var cannythresh1 = 30.0
        var cannythresh2 = 0.0
        var bilateralD = 5.0
        var bilateralQC = 100.0
        var bilateralQS = 100.0
    }
    
    
    // singleton
    static let shared = NGSQLiteManager()
    
//    let queue: FMDatabaseQueue
    
    
    private init() {
        
        let dbName = "LCDdetection.db"
        
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = (path as NSString).appendingPathComponent(dbName)
        
        printLog(path)
        
        // 创建数据库队列，同时‘创建或者打开’数据库
//        queue = FMDatabaseQueue(path: path)
        
        
        createTable()
        
    }
}



extension NGSQLiteManager {
    
    func saveBadPointParam(thresh: Double, maxval: Double, cannyThresh1: Double, cannyThresh2: Double, bilateralD: Double, bilateralQC: Double, bilateraQS: Double) {
        
        
        let sqlf = "select * from BadPointDetect"
        
//        queue.inDatabase { (db) in
//
//            do {
//                let rs = try db?.executeQuery(sqlf, values: nil)
//
//                if rs?.next() == true {
//
//                    db?.executeUpdate("UPDATE BadPointDetect set thresh = ?, maxval = ?,cannythresh1 = ?,cannythresh2 = ?,bilateraD = ?,bilateraQC = ?,bilateraQS = ?", withArgumentsIn: [thresh,maxval,cannyThresh1,cannyThresh2,bilateralD,bilateralQC,bilateraQS])
//
//
//                }else {
//
//                    db?.executeUpdate("INSERT INTO BadPointDetect(thresh, maxval,cannythresh1,cannythresh2,bilateraD,bilateraQC,bilateraQS) VALUES(?,?,?,?,?,?,?)", withArgumentsIn: [thresh,maxval,cannyThresh1,cannyThresh2,bilateralD,bilateralQC,bilateraQS])
//
//                }
//
//                rs?.close()
//
//            }catch {
//                printLog(error)
//            }
//        }
//
//        queue.close()
        
    }
    
    
    func getBadPointParam() -> (SqlBadPointParam?) {
        
        var p: SqlBadPointParam?
        let sql = "select * from BadPointDetect"
        
//        queue.inDatabase { (db) in
//
//            do {
//                let rs = try db?.executeQuery(sql, values: nil)
//
//                if rs?.next() == true {
//
//                    p = SqlBadPointParam()
//
//                    guard let thresh = rs?.double(forColumn: "thresh"),
//                        let maxval = rs?.double(forColumn: "maxval"),
//                        let cannyThresh1 = rs?.double(forColumn: "cannythresh1"),
//                        let cannyThresh2 = rs?.double(forColumn: "cannythresh2"),
//                        let bilateralD = rs?.double(forColumn: "bilateraD"),
//                        let bilateralQC = rs?.double(forColumn: "bilateraQC"),
//                        let bilateralQS = rs?.double(forColumn: "bilateraQS")
//                        else {
//                            return
//                    }
//
//                    p?.thresh = thresh
//                    p?.maxval = maxval
//                    p?.cannythresh1 = cannyThresh1
//                    p?.cannythresh2 = cannyThresh2
//                    p?.bilateralD = bilateralD
//                    p?.bilateralQC = bilateralQC
//                    p?.bilateralQS = bilateralQS
//
//                }
//
//                rs?.close()
//
//            }catch {
//                printLog(error)
//            }
//        }
//
//        queue.close()
        
        
        return p
    }
    
}



private extension NGSQLiteManager {
    
    
    func createTable() {
        
        guard let path = Bundle.main.path(forResource: "LCDDetection.sql", ofType: nil),
            let sql = try? String(contentsOfFile: path) else {
                return
        }
        
//        queue.inDatabase { (db) in
//            if db?.executeStatements(sql) == true {
//                printLog("success")
//            }else {
//                printLog("error")
//            }
//        }
        
    }
}
