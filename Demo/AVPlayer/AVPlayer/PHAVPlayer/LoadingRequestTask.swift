//
//  LoadingRequestTask.swift
//  AVPlayer
//
//  Created by  user on 2018/9/7.
//  Copyright © 2018 NG. All rights reserved.
//

import Foundation
import AVKit


protocol LoadingRequestTaskDelegate: NSObjectProtocol {
    func LoadingRequestTaskDidResponse(_ response: URLResponse)
    func LoadingRequestTaskDidReciveData()
    func LoadingRequestTaskDidComplete(_ isCahce: Bool)
    func LoadingRequestTaskFail(_ error: Error?)
}

class LoadingRequestTask: NSObject {
    
    var session: URLSession?
    var task: URLSessionTask?
    var fileLength: Int64 = 0
    var cacheLength: Int64 = 0
    var startOffset: Int64 = 0
    var cancel = false 
    var url: URL?
    var delegate: LoadingRequestTaskDelegate?
    var cache = false
    var requestOffset: Int64 = 0
    
    override init() {
        _ = LocalLoadDataHandle.createTempFile()
        super.init()
    }
    
    func start() {
        guard let url = url?.httpSchemeURL else {
            return
        }
        var endOffset: Int64 = 1
        if fileLength > 0 {
            endOffset = fileLength - 1
        }
        let mRequest = NSMutableURLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
        let value = "bytes=\(startOffset)-\(endOffset)"
        printLog("requestTask range  \(value)")
        mRequest.addValue(value, forHTTPHeaderField: "Range")
        session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        let request = mRequest as URLRequest
        task = session?.dataTask(with: request)
        task?.resume()
    }
}

extension LoadingRequestTask: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        printLog("didReceive response")
        if let mimeType = response.mimeType {
            if !mimeType.contains("video/") && !mimeType.contains("audio/") && !mimeType.contains("application") {
                printLog("response  cancel")
                completionHandler(.cancel)
                return
            } else {
                delegate?.LoadingRequestTaskDidResponse(response)
            }
        }
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if cancel {
            return
        }
        printLog("didReceive data")
        LocalLoadDataHandle.writeTempFile(data)
        self.cacheLength += Int64(data.count)
        delegate?.LoadingRequestTaskDidReciveData()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if cancel {
            return
        } else {
            if error != nil {
                delegate?.LoadingRequestTaskFail(error)
            } else {
                if self.cache {
                    if let requestUrl = url,
                        let fileName = LocalLoadDataHandle.fileName(requestUrl) {
                        LocalLoadDataHandle.cacheTempFile(fileName)
                    }
                    
                    delegate?.LoadingRequestTaskDidComplete(cache)
                }
            }
        }
    }
}
