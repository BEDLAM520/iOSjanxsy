//
//  URL+Extention.swift
//  AVPlayer
//
//  Created by  user on 2018/7/12.
//  Copyright © 2018 NG. All rights reserved.
//

import Foundation

extension URL {
    var streamingSchemeURL: URL {
        var componts = URLComponents(url: self, resolvingAgainstBaseURL: false)
        componts?.scheme = "streaming"
        if let url = componts?.url {
            return url
        }
        return self
    }

    var httpSchemeURL: URL {
        var componts = URLComponents(url: self, resolvingAgainstBaseURL: false)
        componts?.scheme = "http"
        if let url = componts?.url {
            return url
        }
        return self
    }
}
