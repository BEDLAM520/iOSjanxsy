//
//  AVPlayerOperationView.swift
//  AVPlayer
//
//  Created by  user on 2018/7/11.
//  Copyright © 2018 NG. All rights reserved.
//

import UIKit
import AVKit

class AVPlayerOperationView: UIView {

    var playerview: AVPlayerView!
    var playStatusView: AVPlayerStatusView!
    private var tempFrame: CGRect!

    init(frame: CGRect, urlString: String) {
        super.init(frame: frame)

        tempFrame = frame

        playerview = AVPlayerView(frame: bounds, urlString: urlString)
        playerview.delegate = self
        addSubview(playerview)

        playStatusView = AVPlayerStatusView(frame: CGRect(x: 0, y: height - 30, width: width, height: 30))
        playStatusView.delegate = self
        addSubview(playStatusView)

        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged(noti:)), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }

    @objc private func orientationChanged(noti: Notification) {
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            printLog("ll")
//            UIView.animate(withDuration: 0.25) {
//                self.frame = UIScreen.main.bounds
//            }
            let screenBounds = UIScreen.main.bounds
            let newFrame = screenBounds
            let newCenter = CGPoint(x: screenBounds.midX, y: screenBounds.minY)
            self.bounds = newFrame
            self.center = newCenter
            self.transform = CGAffineTransform(rotationAngle: .pi * 2)
        case .landscapeRight:
            printLog("lr")
            UIView.animate(withDuration: 0.25) {
                self.frame = UIScreen.main.bounds
            }
        case .portrait:
            printLog("p")
            UIView.animate(withDuration: 0.25) {
                self.frame = self.tempFrame
            }
        default:
            break
        }


    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerview.frame = bounds
        playStatusView.frame = CGRect(x: 0, y: height - 30, width: width, height: 30)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AVPlayerOperationView: AVPlayerStatusViewDelegate {
    func AVPlayerStatusViewPlay(didPlay: Bool) {
        playerview.playerPlay(didPlay: didPlay)
    }


    func AVPlayerStatusViewSeek(time: CMTime) {
        playerview.playerSeek(time: time) {
            self.playStatusView.finishDrag()
        }
    }
}

extension AVPlayerOperationView: AVPlayerViewDelegate {
    func AVPlayerViewDidGetDuration(time: CMTime) {
        playStatusView.setDuration(time)
    }

    func AVPlayerViewDidChangeCurrentTime(time: CMTime) {
        playStatusView.setCurrentTime(time)
    }

    func AVPlayerViewBufferLoaded(progress: CGFloat) {
        playStatusView.setBuffer(progress)
    }
}
