//
//  AVPlayerViewLayer.swift
//  AVPlayer
//
//  Created by  user on 2018/7/11.
//  Copyright © 2018 NG. All rights reserved.
//

import UIKit

class AVPlayerViewLayer: CALayer {
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var playerView: UIView?
    var playerLayer: AVPlayerLayer?
    var aVURLAsset: AVURLAsset?
    var periodicTimeObserver: Any?

    init
}

extension AVPlayerViewLayer: AVAssetResourceLoaderDelegate {

}
