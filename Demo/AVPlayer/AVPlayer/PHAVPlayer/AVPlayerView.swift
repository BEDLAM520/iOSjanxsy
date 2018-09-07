//
//  AVPlayerView.swift
//  AVPlayer
//
//  Created by  user on 2018/7/11.
//  Copyright © 2018 NG. All rights reserved.
//

import UIKit
import AVKit

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
                printLog(error?.localizedDescription)
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

    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForResponseTo authenticationChallenge: URLAuthenticationChallenge) -> Bool {
        printLog("-----1")
        return true
    }

    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel authenticationChallenge: URLAuthenticationChallenge) {
        printLog("-----2")
    }

    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForRenewalOfRequestedResource renewalRequest: AVAssetResourceRenewalRequest) -> Bool {
        printLog("-----3")
        return true
    }

    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        printLog("---cancel   \(loadingRequest.dataRequest?.requestedOffset)    \(loadingRequest.dataRequest?.currentOffset)  \(loadingRequest.dataRequest?.requestedLength)")
    }

    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        printLog("---wait   \(loadingRequest.dataRequest?.requestedOffset)    \(loadingRequest.dataRequest?.currentOffset)  \(loadingRequest.dataRequest?.requestedLength)")

//        guard let resourceURL = loadingRequest.request.url else {
//                return true
//        }
//
//        if resourceURL.absoluteString.hasPrefix(kCacheScheme) {
//            if originUrlStr == nil {
//               originUrlStr = resourceURL.absoluteString.replacingOccurrences(of: kCacheScheme, with: "")
//            }
//
//            guard let dataRequest = loadingRequest.dataRequest else {
//                return false
//            }
//
//            var offset = dataRequest.requestedOffset
//            let length = dataRequest.requestedLength
//
//            if dataRequest.currentOffset != 0 {
//                offset = dataRequest.currentOffset
//            }
//
//            let toEnd = dataRequest.requestsAllDataToEndOfResource == true
//            printLog("\(offset)   \(length)   \(dataRequest.currentOffset)     \(dataRequest.requestedOffset)   \(toEnd)")
//
//            let range = NSRange(location: Int(offset), length: length)
//            if toEnd {
//
//            }
//
//            cacheDataAction(range)
//        }

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

extension AVPlayerView {
    func start(url: URL, requestOffset: Int64, fileLength: Int) {
        var request = URLRequest(url: url.httpSchemeURL, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        if requestOffset > 0 {
            request.addValue("bytes=\(requestOffset)-\(fileLength)", forHTTPHeaderField: "Range")
        }
        session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        task = session?.dataTask(with: request)
        task?.resume()
    }
}

extension AVPlayerView: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(.allow)

        guard let httpReponse = response as? HTTPURLResponse else {
            return
        }
        printLog(httpReponse)
        let contentRange = httpReponse.allHeaderFields["Content-Range"]

        printLog(contentRange)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        printLog(data)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        printLog(error)
    }
}
