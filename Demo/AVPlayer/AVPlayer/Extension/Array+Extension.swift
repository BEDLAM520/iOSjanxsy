//
//  Array+Extension.swift
//  AVPlayer
//
//  Created by  user on 2018/9/11.
//  Copyright © 2018 NG. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    /// 移除数组中的某元素
    ///
    /// - Parameter item: 要移除的元素
    public mutating func remove(_ item: Element) {
        if let idx = self.index(of: item) {
            remove(at: idx)
        }
    }
    
    public mutating func removeObjectsIn(_ array: [Element]) {
        for item in array {
            remove(item)
        }
    }
}
