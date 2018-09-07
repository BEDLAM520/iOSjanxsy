//
//  AVPlayerStatusView.swift
//  AVPlayer
//
//  Created by  user on 2018/7/10.
//  Copyright © 2018 NG. All rights reserved.
//

import UIKit
import CoreMedia

@objc protocol AVPlayerStatusViewDelegate: NSObjectProtocol {
    func AVPlayerStatusViewSeek(time: CMTime)
    func AVPlayerStatusViewPlay(didPlay: Bool)
}

class AVPlayerStatusView: UIView {

    weak var delegate: AVPlayerStatusViewDelegate?
    private lazy var blockHeight: CGFloat = 12
    private lazy var blockWidth: CGFloat = 8
    private lazy var barHeight: CGFloat = 1.5
    private lazy var timeLabelWidth: CGFloat = 48
    private lazy var margin: CGFloat = 10

    private var dragView: UIView!
    private var durationView: UIView!
    private var bufferView: UIView!
    private var playBtn: UIButton!
    private var currentTimeLabel: UILabel!
    private var totalTimeLabel: UILabel!
    private var fullScreenBtn: UIButton!

    private lazy var startTouchPoint = CGPoint.zero
    private lazy var canMove = false
    private lazy var startTouchFrame = CGRect.zero

    private var playItemDuration: TimeInterval = 0
    private var currentTimeProgress: CGFloat = 0
    private var bufferProgress: CGFloat = 0
    private var isDrag = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        durationView = UIView()
        durationView.backgroundColor = UIColor.white
        addSubview(durationView)

        bufferView = UIView()
        bufferView.backgroundColor = UIColor.red
        addSubview(bufferView)

        dragView = UIView()
        dragView.backgroundColor = UIColor.white
        dragView.layer.cornerRadius = 3
        dragView.layer.masksToBounds = true
        addSubview(dragView)

        playBtn = UIButton()
        playBtn.addTarget(self, action: #selector(playAction(_:)), for: .touchUpInside)
        playBtn.setTitle("P", for: .normal)
        playBtn.setTitle("S", for: .selected)
        playBtn.backgroundColor = UIColor.red
        addSubview(playBtn)

        fullScreenBtn = UIButton()
        fullScreenBtn.backgroundColor = UIColor.blue
        addSubview(fullScreenBtn)

        currentTimeLabel = UILabel()
        currentTimeLabel.text = "00:00"
        currentTimeLabel.textColor = UIColor.white
        currentTimeLabel.font = UIFont.boldSystemFont(ofSize: 9)
        currentTimeLabel.textAlignment = .right
        addSubview(currentTimeLabel)

        totalTimeLabel = UILabel()
        totalTimeLabel.text = "00:00"
        totalTimeLabel.textColor = currentTimeLabel.textColor
        totalTimeLabel.font = currentTimeLabel.font
        totalTimeLabel.textAlignment = .left
        addSubview(totalTimeLabel)

        backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        playBtn.frame = CGRect(x: 10, y: 0, width: height, height: height)
        currentTimeLabel.frame = CGRect(x: playBtn.right + margin, y: 0, width: timeLabelWidth, height: height)
        fullScreenBtn.frame = CGRect(x: width - height - margin, y: 0, width: height, height: height)
        totalTimeLabel.frame = CGRect(x: fullScreenBtn.left - timeLabelWidth - margin, y: 0, width: timeLabelWidth, height: height)

        let canDragWidth = progressWidth()
        durationView.frame = CGRect(x: currentTimeLabel.right + margin, y: (frame.height - barHeight) * 0.5, width: canDragWidth, height: barHeight)
        dragView.frame = CGRect(x: currentTimeProgress * canDragWidth + durationView.left, y: (frame.height - blockHeight) * 0.5, width: blockWidth, height: blockHeight)
        bufferView.frame = CGRect(x: durationView.left, y: durationView.top, width: bufferProgress * canDragWidth, height: barHeight)
    }

    @objc private func playAction(_ sender: UIButton) {
        printLog("--")
        sender.isSelected = !sender.isSelected
        delegate?.AVPlayerStatusViewPlay(didPlay: sender.isSelected)
    }

    private func progressWidth() -> CGFloat {
        return totalTimeLabel.left - margin*2 - currentTimeLabel.right
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if playItemDuration == 0 {
            return
        }

        guard let touch = (touches as NSSet).anyObject() else {
            return
        }
        
        let touchPoint = (touch as AnyObject).location(in: self)
        startTouchPoint = touchPoint
        canMove = atBlockRange(touchPoint)
        startTouchFrame = dragView.frame
        isDrag = true
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        guard let touch = (touches as NSSet).anyObject() else {
            return
        }

        let touchPoint = (touch as AnyObject).location(in: self)
        if canMove == false {
            return
        }

        if startTouchFrame.equalTo(CGRect.zero) == false {
            var x = touchPoint.x - startTouchPoint.x + startTouchFrame.origin.x
            if x < durationView.left {
                x = durationView.left
            }

            let canDragWidth = progressWidth()
            if x >= canDragWidth + durationView.left {
                x = canDragWidth + durationView.left
            }
            dragView.left = x
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if canMove {
            let x = dragView.left - durationView.left
            let progress = x / progressWidth()
            currentTimeProgress = progress
            let seekDuration = TimeInterval(progress) * playItemDuration * 1000000000
            let seekTime = CMTime(value: CMTimeValue(seekDuration), timescale: 1000000000)
            delegate?.AVPlayerStatusViewSeek(time: seekTime)
        }
        canMove = false
    }
}

private extension AVPlayerStatusView {
    func atBlockRange(_ touchPoint: CGPoint) -> Bool {
        let moreRange: CGFloat = 20
        let dragFrame = dragView.frame
        let atX = (dragFrame.origin.x - moreRange) <= touchPoint.x && (dragFrame.origin.x + dragFrame.width + moreRange) >= touchPoint.x
        let atY = (dragFrame.origin.y - moreRange) <= touchPoint.y && (dragFrame.origin.y + dragFrame.height + moreRange) >= touchPoint.y
        return atX && atY
    }
}

extension AVPlayerStatusView {
    func setBuffer(_ progress: CGFloat) {
        bufferProgress = progress
        if isDrag == false {
            setNeedsLayout()
        }
    }

    func setDuration(_ duration: CMTime) {
        playItemDuration = duration.seconds
        totalTimeLabel.text = TimeFormat(totalSeconds: duration.seconds).timeFormatString
    }

    func setCurrentTime(_ currentTime: CMTime) {
        currentTimeProgress = CGFloat(currentTime.seconds / playItemDuration)
        currentTimeLabel.text = TimeFormat(totalSeconds: currentTime.seconds).timeFormatString
        if isDrag == false {
            setNeedsLayout()
        }
    }

    func finishDrag() {
        isDrag = false
    }
}
