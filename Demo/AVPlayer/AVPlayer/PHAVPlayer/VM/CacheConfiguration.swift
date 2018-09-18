//
//  CacheConfiguration.swift
//  AVPlayer
//
//  Created by  user on 2018/9/17.
//  Copyright © 2018 NG. All rights reserved.
//

import Foundation

struct CacheConfiguration {
    var filePath: String?
    
    static func configurationWith(_ filePath: String) -> CacheConfiguration {
        if let filePath = configurationFilePathFor(filePath),
        var configuration = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? CacheConfiguration {
            configuration.filePath = filePath
            return configuration
        } else {
            var configuration = CacheConfiguration()
            configuration.filePath = (filePath as NSString).lastPathComponent
            return configuration
        }
    }
    
    static func configurationFilePathFor(_ filePath: String) -> String? {
        return filePath.appendingPathExtension("mt_cfg")
    }
}
