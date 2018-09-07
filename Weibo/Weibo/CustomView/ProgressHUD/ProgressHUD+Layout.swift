//
//  ProgressHUD+Layout.swift
//  UploadTool
//
//  Created by  user on 2018/5/23.
//  Copyright © 2018年 NG. All rights reserved.
//

import UIKit

extension ProgressHUD {

    func setupLabels() {
        label = UILabel(frame: bounds)
        label!.adjustsFontSizeToFitWidth = false
        label!.textAlignment = .center
        label!.isOpaque = false
        label!.backgroundColor = UIColor.clear

        addSubview(label!)

        detailsLabel = UILabel(frame: bounds)
        detailsLabel!.adjustsFontSizeToFitWidth = false
        detailsLabel!.textAlignment = .center
        detailsLabel!.isOpaque = false
        detailsLabel!.backgroundColor = UIColor.clear
        detailsLabel!.numberOfLines = 0
        addSubview(detailsLabel!)
    }

    func updateModeView() {
        rotationView?.removeFromSuperview()
        progressView?.removeFromSuperview()
        indicator.removeFromSuperview()
        customView?.removeFromSuperview()
        succeedView?.removeFromSuperview()

        switch mode {
        case .grayIndicator:
            indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            indicator.startAnimating()
            addSubview(indicator)
        case .indicatorAndText, .largeWhiteIndicator:
            indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            indicator.startAnimating()
            addSubview(indicator)
        case .rotate:
            rotationView = RotationView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            addSubview(rotationView!)
        case .progress:
            progressView = CircleProgressView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            progressView?.backgroundColor = UIColor.clear
            backgroundColor = UIColor.black.withAlphaComponent(0.1)
            addSubview(progressView!)
        case .customView:
            backgroundColor = UIColor.black.withAlphaComponent(0.1)
            if let v = customView {
                addSubview(v)
            }
        case .succeedStatus:
            succeedView = SucceedStatusView(frame: CGRect(x: 30, y: 0, width: bounds.width - 60, height: 160))
            succeedView?.backgroundColor = UIColor.clear
            addSubview(succeedView!)
            backgroundColor = UIColor.clear
            viewSize = succeedView!.frame.size
        default:
            break
        }
    }

    func indicatorAndTextSize() {
        let maxWidth = bounds.width - 8 * margin
        var totalSize = CGSize.zero, indicatorF = CGRect.zero

        if mode == .indicatorAndText || mode == .largeWhiteIndicator {
            indicatorF = indicator.bounds
            indicatorF.size.width = min(indicatorF.width, maxWidth)
            totalSize = indicatorF.size
        }

        if mode == .largeWhiteIndicator {
            totalSize.width += 4 * margin
            totalSize.height += 4 * margin
            viewSize = totalSize
            return
        }

        var labelSize = String.textSize(labelText, labelFont)
        labelSize.width = min(labelSize.width, maxWidth)
        totalSize.width = max(totalSize.width, labelSize.width)
        totalSize.height += labelSize.height
        if labelSize.height > 0 && indicatorF.height > 0 {
            totalSize.height += kPadding
        }

        let remainingHeight = bounds.height - totalSize.height - kPadding - 4 * margin
        let maxSize = CGSize(width: maxWidth, height: remainingHeight)

        let detailLabelSize = String.multiLineTextSize(detailsLabelText, maxSize, detailsLabelFont)
        totalSize.width = max(totalSize.width, detailLabelSize.width)
        totalSize.height += detailLabelSize.height
        if detailLabelSize.height > 0 && (indicatorF.height > 0 || labelSize.height > 0) {
            totalSize.height += kPadding
        }

        totalSize.width += 2 * margin
        totalSize.height += 2 * margin

        var yPos = round((bounds.height - totalSize.height) * 0.5) + margin + yOffset
        let xPos = xOffset
        indicatorF.origin.y = yPos
        indicatorF.origin.x = round((bounds.width - indicatorF.width) * 0.5) + xPos
        indicator.frame = indicatorF
        yPos += indicatorF.height

        if labelSize.height > 0 && indicatorF.size.height > 0.5 {
            yPos += kPadding
        }

        label!.frame = CGRect(x: round((bounds.width - labelSize.width) * 0.5) + xPos,
                              y: yPos, width: labelSize.width, height: labelSize.height)
        yPos += label!.frame.height

        if detailLabelSize.height > 0 && (indicatorF.height > 0 || labelSize.height > 0) {
            yPos += kPadding
        }

        detailsLabel!.frame = CGRect(x: round((bounds.width - detailLabelSize.width) * 0.5) + xPos,
                                     y: yPos, width: detailLabelSize.width, height: detailLabelSize.height)

        setSquare(totalSize, minSize)
    }

    private func setSquare(_ totalsize: CGSize, _ minSize: CGSize) {
        var totalSize = totalsize
        if square {
            let maxv = max(totalSize.width, totalSize.height)
            if maxv <= bounds.width - 2 * margin {
                totalSize.width = maxv
            }
            if maxv <= bounds.height - 2 * margin {
                totalSize.height = maxv
            }
        }
        totalSize.width = max(totalSize.width, minSize.width)
        totalSize.height = max(totalSize.height, minSize.height)
        viewSize = totalSize
    }
}
