//
//  String+Extension.swift
//  AVPlayer
//
//  Created by  user on 2018/9/17.
//  Copyright © 2018 NG. All rights reserved.
//

import Foundation

extension String {
    func appendingPathExtension(_ lastExtension: String) -> String? {
        return (self as NSString).appendingPathExtension(lastExtension)
    }
}
