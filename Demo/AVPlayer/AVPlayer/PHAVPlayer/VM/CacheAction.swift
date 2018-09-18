//
//  CacheAction.swift
//  AVPlayer
//
//  Created by  user on 2018/9/4.
//  Copyright © 2018 NG. All rights reserved.
//

import Foundation

enum CacheActionType {
    case local
    case remote
}


struct CacheAction {
    var actionType: CacheActionType
    var range: NSRange
    
    func isEqual(_ action: CacheAction) -> Bool {
        if !NSEqualRanges(range, action.range) {
            return false
        }
        
        if action.actionType != self.actionType {
            return false
        }
        return true
    }
}
