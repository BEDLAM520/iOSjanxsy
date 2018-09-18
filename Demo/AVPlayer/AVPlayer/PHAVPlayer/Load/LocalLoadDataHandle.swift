//
//  LocalLoadDataHandle.swift
//  AVPlayer
//
//  Created by  user on 2018/9/14.
//  Copyright © 2018 NG. All rights reserved.
//

import Foundation

struct LocalLoadDataHandle {
    static func createTempFile() -> Bool {
        let mgr = FileManager.default
        let path = self.tempFilePath
        if mgr.fileExists(atPath: path) {
            do {
                try mgr.removeItem(atPath: path)
            } catch {
                assert(true, error.localizedDescription)
            }
        }
        return mgr.createFile(atPath: path, contents: nil, attributes: nil)
    }
    
    static func writeTempFile(_ data: Data) {
        let handle = FileHandle(forWritingAtPath: self.tempFilePath)
        handle?.seekToEndOfFile()
        handle?.write(data)
    }
    
    static func readTempFile(dataOffset offset: Int64, dataLength lenght: Int64) -> Data? {
        let hanle = FileHandle(forReadingAtPath: self.tempFilePath)
        hanle?.seek(toFileOffset: UInt64(offset))
        return hanle?.readData(ofLength: Int(lenght))
    }
    
    static func cacheTempFile(_ fileName: String) {
        let mgr = FileManager.default
        let cacheFolderPath = self.cacheFolderPath
        if mgr.fileExists(atPath: self.cacheFolderPath) == false {
            do {
                try mgr.createDirectory(atPath: cacheFolderPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                assert(true, error.localizedDescription)
            }
        }
        
        let  cacheFilePath = "\(self.cacheFolderPath)/\(fileName)"
//        do {
//            try FileManager.default.copyItem(atPath: self.tempFilePath, toPath: cacheFilePath)
//            
//        } catch  {
//            printLog(error.localizedDescription)
//        }
    }
    
    static func cacheFileExists(_ url: URL) -> String? {
        guard let fileUrl = self.fileName(url) else {
            return nil
        }
        let cacheFilePath = "\(self.cacheFolderPath)/\(fileUrl)"
        if FileManager.default.fileExists(atPath: cacheFilePath) {
            return cacheFilePath
        }
        return nil
    }
    
    static func clearCache() -> Bool {
        do {
            try FileManager.default.removeItem(atPath: self.cacheFolderPath)
            return true
        } catch  {
            printLog(error.localizedDescription)
            return false
        }
    }
}

extension LocalLoadDataHandle {
    static var tempFilePath: String {
        return NSHomeDirectory().appending("/tmp").appending("/MusicTemp.mp4")
    }
    
    static var cacheFolderPath: String {
        return NSHomeDirectory().appending("/Library").appending("/MusicCaches")
    }
    
    static func fileName(_ url: URL) -> String? {
        return url.path.components(separatedBy: "/").last
    }
}
