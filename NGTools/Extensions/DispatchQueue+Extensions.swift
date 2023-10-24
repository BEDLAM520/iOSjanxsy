//
//  DispatchQueue+Extensions.swift
//  NGTools
//
//  Created by liaonaigang on 2022/1/1.
//  Copyright © 2022 ngliao. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    func Global_async(completion:@escaping ()->()) {

        DispatchQueue.main.async {
            completion()
        }
    }
}
