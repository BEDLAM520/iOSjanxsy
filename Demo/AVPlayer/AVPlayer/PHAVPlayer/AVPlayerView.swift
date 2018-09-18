//
//  AVPlayerView.swift
//  AVPlayer
//
//  Created by  user on 2018/7/11.
//  Copyright © 2018 NG. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices

let kCacheScheme = "__VIMediaCache___:"
let kPackageLength = 204800 // 200kb per package
let kMCMediaCacheResponseKey = "kMCMediaCacheResponseKey"
let VIMediaCacheErrorDoamin = "com.vimediacache"


@objc protocol AVPlayerViewDelegate: NSObjectProtocol {
    func AVPlayerViewDidGetDuration(time: CMTime)
    func AVPlayerViewDidChangeCurrentTime(time: CMTime)
    func AVPlayerViewBufferLoaded(progress: CGFloat)
}

class AVPlayerView: UIView {
    
    weak var delegate: AVPlayerViewDelegate?
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var playerLayer: AVPlayerLayer?
    var periodicTimeObserver: Any?
    
    var session: URLSession?
    var task: URLSessionDataTask?
    var requestTask: LoadingRequestTask?
    var requestList = [AVAssetResourceLoadingRequest]()
    var seekRequired = false
    var cacheFinished = false
    //////
    var originUrlStr: String?
    
    
    init(frame: CGRect, urlString: String) {
        super.init(frame: frame)
        
        guard let videoUrl = URL(string: urlString)?.streamingSchemeURL else {
            return
        }
        
        let urlAsset = AVURLAsset(url: videoUrl, options:nil)
        urlAsset.resourceLoader.setDelegate(self, queue: DispatchQueue.main)
        playerItem = AVPlayerItem(asset: urlAsset)
        
        player = AVPlayer(playerItem: playerItem)
        
        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        layer.contentsScale = UIScreen.main.scale
        layer.frame = self.bounds
        self.layer.addSublayer(layer)
        playerLayer = layer
        player?.play()
        
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: nil)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges), options: .new, context: nil)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferEmpty), options: .new, context: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playToEnd(noti:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferEmpty))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges))
        NotificationCenter.default.removeObserver(self)
        guard let periodicTimeObserver = periodicTimeObserver else {
            return
        }
        player?.removeTimeObserver(periodicTimeObserver)
        printLog("denit \(self)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}

extension AVPlayerView {
    @objc func playToEnd(noti: Notification) {
        printLog("------end")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // Only handle observations for the playerItemContext
        guard let playerItem = object as? AVPlayerItem else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: nil)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            switch playerItem.status {
            case .readyToPlay:
                delegate?.AVPlayerViewDidGetDuration(time: playerItem.duration)
                let interval = CMTime(seconds: 0.5,
                                      preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                let mainQueue = DispatchQueue.main
                periodicTimeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: {[weak self] (time) in
                    self?.delegate?.AVPlayerViewDidChangeCurrentTime(time: playerItem.currentTime())
                })
            case .failed:
                let error = playerItem.error
                printLog("\(error?.localizedDescription)  \(error)")
            case .unknown:
                printLog("player unknown")
            }
        } else if keyPath == #keyPath(AVPlayerItem.loadedTimeRanges) {
            let loadedTimeRanges = playerItem.loadedTimeRanges
            if let timeRange = loadedTimeRanges.first?.timeRangeValue {  // 获取缓冲区域
                let result = timeRange.start.seconds + timeRange.duration.seconds  // 计算缓冲总进度
                let progroess = result / playerItem.duration.seconds
                delegate?.AVPlayerViewBufferLoaded(progress: CGFloat(progroess))
            }
        } else if keyPath == #keyPath(AVPlayerItem.isPlaybackBufferEmpty) {
            printLog(playerItem.isPlaybackBufferEmpty)
        }
    }
}

extension AVPlayerView {
    func playerPlay(didPlay: Bool) {
        if didPlay {
            player?.pause()
        } else {
            player?.play()
        }
    }
    
    func playerSeek(time: CMTime, completion: @escaping (()->())) {
        player?.seek(to: time, completionHandler: { (finished) in
            if finished {
                self.player?.play()
            }
            completion()
        })
    }
}

extension AVPlayerView: AVAssetResourceLoaderDelegate {
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        printLog("---didCancel   \(loadingRequest.dataRequest?.requestedOffset)    \(loadingRequest.dataRequest?.currentOffset)  \(loadingRequest.dataRequest?.requestedLength)")
        requestList.remove(loadingRequest)
    }
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        printLog("---shouldWait   \(loadingRequest.dataRequest?.requestedOffset)    \(loadingRequest.dataRequest?.currentOffset)  \(loadingRequest.dataRequest?.requestedLength)")
        addLoadingRequest(loadingRequest)
        return true
    }
    
    
    
    func cacheDataAction(_ range: NSRange) {
        
        if range.location == NSNotFound {
            return
        }
        
        let cachedFragments = [NSValue]()
        var actions = [NSRange]()
        
        let endOffset = range.location + range.length
        
        for item in cachedFragments {
            let fragmentRange = item.rangeValue
            let intersectionRange = NSIntersectionRange(range, fragmentRange)
            if intersectionRange.length > 0 {
                let package = intersectionRange.length / kPackageLength
                for i in 0...package {
                    let offset = i * kPackageLength
                    let offsetLocation = intersectionRange.location + offset
                    let maxLocation = intersectionRange.location + intersectionRange.length
                    let length = (offsetLocation + kPackageLength) > maxLocation ? (maxLocation + offsetLocation) : kPackageLength
                    actions.append(NSRange(location: offsetLocation, length: length))
                }
            } else if (fragmentRange.location >= endOffset) {
                break
            }
        }
    }
    
    func keyForResourceLoaderWithURL(requestURL: URL) -> String? {
        if requestURL.absoluteString.hasPrefix(kCacheScheme) {
            return requestURL.absoluteString
        }
        return nil
    }
}

extension AVPlayerView: LoadingRequestTaskDelegate {
    func stopLoading() {
        self.requestTask?.cancel = true
    }
    
    func addLoadingRequest(_ loadingRequest: AVAssetResourceLoadingRequest) {
        requestList.append(loadingRequest)
        printLog("request list count    \(requestList.count)")
        synchronized(lock: self) {
            if self.requestTask != nil {
                if let requestTask = self.requestTask,
                    let requestedOffset = loadingRequest.dataRequest?.requestedOffset {
                    if  requestedOffset >= requestTask.requestOffset
                        && requestedOffset <= requestTask.requestOffset + requestTask.cacheLength {
                        printLog("----1")
                        self.processRequestList()
                    } else {
                        printLog("----2")
                        if self.seekRequired {
                            printLog("----3")
                            self.newTaskWith(loadingRequest, false)
                        }
                    }
                }
            } else {
                printLog("----4")
                self.newTaskWith(loadingRequest, true)
            }
        }
    }
    
    func newTaskWith(_ loadingRequest: AVAssetResourceLoadingRequest, _ cache: Bool) {
        var fileLength = 0
        if let task = requestTask {
            fileLength = Int(task.fileLength)
            task.cancel = true
        }
        
        requestTask = LoadingRequestTask()
        requestTask?.url = loadingRequest.request.url
        if let requestedOffset = loadingRequest.dataRequest?.requestedOffset {
            requestTask?.requestOffset = Int64(requestedOffset)
        }
        requestTask?.cache = cache
        if fileLength > 0 {
            requestTask?.fileLength = Int64(fileLength)
        }
        requestTask?.delegate = self
        requestTask?.start()
        seekRequired = false
    }
    
    func processRequestList() {
        var finishRequestList = [AVAssetResourceLoadingRequest]()
        for item in requestList {
            if finishLoadingWith(item) {
                finishRequestList.append(item)
            }
        }

        requestList.removeObjectsIn(finishRequestList)
    }
    
    func finishLoadingWith(_ loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        
        guard let requestedOffset = loadingRequest.dataRequest?.requestedOffset,
            let currentOffset = loadingRequest.dataRequest?.currentOffset,
            let requestedLength = loadingRequest.dataRequest?.requestedLength,
            let task = requestTask else {
                return false
        }
        
//        if let contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType,
//                                                                   "video/mp4" as CFString,
//                                                                   nil)?.takeRetainedValue() as String? {
            loadingRequest.contentInformationRequest?.contentLength = task.fileLength
//            loadingRequest.contentInformationRequest?.contentType = contentType
            loadingRequest.contentInformationRequest?.contentType = "public.mpeg-4"
            loadingRequest.contentInformationRequest?.isByteRangeAccessSupported = true
//        }
        
        var rOffset = requestedOffset
        let cacheLength = task.cacheLength
        if currentOffset != 0 {
            rOffset = currentOffset
        }
//        printLog("data      \(loadingRequest)")
        let  canReadLength = cacheLength - (rOffset - task.requestOffset)
        let respondLength = min(canReadLength, Int64(requestedLength))
        printLog("---offset  \(rOffset)   \(task.requestOffset)   \(respondLength)")
        if let data = LocalLoadDataHandle.readTempFile(dataOffset: rOffset - task.requestOffset, dataLength: respondLength) {
            loadingRequest.dataRequest?.respond(with: data)
        }
        
        let nowEndOffset = rOffset + canReadLength
        let reqEndOffset = requestedOffset + Int64(requestedLength)
        if nowEndOffset >= reqEndOffset {
            printLog("finish loading")
            loadingRequest.finishLoading()
            return true
        }
        return false
    }
    
    
    ////////  MARK   ////////
    func LoadingRequestTaskDidReciveData() {
        processRequestList()
    }
    
    func LoadingRequestTaskDidComplete(_ isCahce: Bool) {
        cacheFinished = isCahce
    }
    
    func LoadingRequestTaskFail(_ error: Error?) {
        printLog(error?.localizedDescription)
    }
    
    func LoadingRequestTaskDidResponse(_ response: URLResponse) {
//        if let mimeType = response.mimeType {
//            for request in requestList {
////                printLog("response mime     \(request)")
//                // FIXME: Int长度范围和视频的长度范围
//                // Content-Length type is NSTaggedPointerString
//                if let httpResponse = response as? HTTPURLResponse,
//                    let acceptRange = httpResponse.allHeaderFields["Accept-Ranges"] as? String,
//                    let contentLengthObj = httpResponse.allHeaderFields["Content-Range"] as? String,
//                    let contentLengthStr = contentLengthObj.components(separatedBy: "/").last,
//                    let contentLength = CLongLong("\(contentLengthStr)"),
//                    let contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType,
//                                                                            mimeType as CFString,
//                                                                            nil)?.takeRetainedValue() as String?
//                {
//                    let isByteRangeAccessSupported = acceptRange == "bytes"
//
//                    self.requestTask?.fileLength = contentLength
//                    request.contentInformationRequest?.contentLength = contentLength
//                    request.contentInformationRequest?.contentType = contentType
//                    request.contentInformationRequest?.isByteRangeAccessSupported = isByteRangeAccessSupported
//                    printLog("contentInformationRequest  \(contentType)  \(contentLength) \(isByteRangeAccessSupported)  \(isByteRangeAccessSupported)    \(contentLengthObj) \(contentLength)")
//                }
//
//            }
//        }
    }
}
