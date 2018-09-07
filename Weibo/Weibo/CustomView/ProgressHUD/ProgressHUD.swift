//
//  ProgressHUD.swift
//  Animation
//
//  Created by  user on 2018/1/10.
//  Copyright © 2018年 NG. All rights reserved.
//

/// almost base on MPProgressHUD, it is wonderful and stable, also can save my time.
/// undo: 1、UIApplicationDidChangeStatusBarOrientationNotification
///       2、MBProgressHUD还为我们提供了一组显示方法，可以让我们在显示HUD的同时，执行一些后台任务，我们在此主要介绍两个。
///        其中一个是-showWhileExecuting:onTarget:withObject:animated:，它是基于target-action方式的调用，
///        在执行一个后台任务时显示HUD，等后台任务执行完成后再隐藏HUD.
import UIKit

enum ProgressHUDMode {
    /** Shows grayIndicator. This is the default. */
    case grayIndicator
    /** Shows LargeWhiteIndicator. This is the default. */
    case largeWhiteIndicator
    /** Progress is shown indicator 、 title and detail */
    case indicatorAndText
    /** Progress is shown using an UIActivityIndicatorView. This is the default. */
    case rotate
    /** Shows labels */
    case text
    /** Shows progress view */
    case progress
    /** Shows custom view */
    case customView
    /** Shows SucceedState view */
    case succeedStatus
}

enum ProgressHUDAnimation {
    /** Opacity animation */
    case fade
    /** Opacity + scale animation */
    case zoom
    case zoomOut
    case zoomIn
}

class ProgressHUD: UIView {
    var labelColor = UIColor.white {didSet {setLayoutDisplay()}}
    var labelFont = UIFont.systemFont(ofSize: 15) {didSet {setLayoutDisplay()}}
    var labelText: String? {didSet {setLayoutDisplay()}}
    var detailsLabelColor = UIColor.white {didSet {setLayoutDisplay()}}
    var detailsLabelFont = UIFont.systemFont(ofSize: 12) {didSet {setLayoutDisplay()}}
    var detailsLabelText: String? {didSet {setLayoutDisplay()}}
    var progress: CGFloat = 0 {didSet {setLayoutDisplay()}}
    var progressDrawColor = UIColor.white {didSet {setLayoutDisplay()}}
    var mode = ProgressHUDMode.grayIndicator {didSet {updateModeView()}}
    var animationType = ProgressHUDAnimation.fade

    // Main Thread Checker: UILabel.text must be used from main thread only
    var label: UILabel?
    var detailsLabel: UILabel?
    var rotationView: RotationView?
    var progressView: CircleProgressView?
    var succeedView: SucceedStatusView?
    lazy var indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var customView: UIView? {didSet {setLayoutDisplay()}}

    let margin: CGFloat = 15
    let kPadding: CGFloat = 4
    let yOffset: CGFloat = 0
    let xOffset: CGFloat = 0

    //IN Vars
    var square = false
    var minSize = CGSize.zero
    var rotationTransform = CGAffineTransform.identity
    var showStarted: Date?
    var useAnimation = false

    /**
     * The actual size of the HUD bezel.
     * You can use this to limit touch handling on the bezel area only.
     * @see https://github.com/jdg/MBProgressHUD/pull/200
     */
    var viewSize = CGSize.zero

    /// The corner radius for the HUD,Defaults to 10.0
    var cornerRadius: CGFloat = 10

    /// The opacity of the HUD window. Defaults to 0.8 (80% opacity).
    var opacity: CGFloat = 0.8

    /**
     * The color of the HUD window. Defaults to black. If this property is set, color is set using
     * this UIColor and the opacity property is not used.  using retain because performing copy on
     * UIColor base colors (like [UIColor greenColor]) cause problems with the copyZone.
     */
    var color: UIColor?

    /// Cover the HUD background view with a radial gradient.
    var dimBackground = false

    /**
     * The minimum time (in seconds) that the HUD is shown.
     * This avoids the problem of the HUD being shown and than instantly hidden.
     * Defaults to 0 (no minimum show time).
     */
    var minShowTime: CGFloat = 0
    var minShowTimer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabels()
        updateModeView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        minShowTimer?.invalidate()
        minShowTimer = nil
    }

    private func setLayoutDisplay() {
        DispatchQueue.main.async {
            if let progressv = self.progressView {
                progressv.drawColor = self.progressDrawColor
                progressv.progress = self.progress
            }
            self.label?.textColor = self.labelColor
            self.label?.font = self.labelFont
            self.label?.text = self.labelText
            self.detailsLabel?.textColor = self.detailsLabelColor
            self.detailsLabel?.font = self.detailsLabelFont
            self.detailsLabel?.text = self.detailsLabelText
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        UIGraphicsPushContext(context)

        if dimBackground {
            let gradLocation: [CGFloat] = [0.0, 1.0]
            let gradColors: [CGFloat] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.75]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            if let gradient = CGGradient(colorSpace: colorSpace, colorComponents: gradColors, locations: gradLocation, count: 2) {
                let gradCenter = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
                let gradRadius = min(bounds.width, bounds.height)
                //Gradient draw
                context.drawRadialGradient(gradient, startCenter: gradCenter,
                                           startRadius: 0,
                                           endCenter: gradCenter,
                                           endRadius: gradRadius,
                                           options: .drawsAfterEndLocation)
            }
        }

        // Set background rect color
        if color != nil {
            context.setFillColor(color!.cgColor)
        } else {
            context.setFillColor(gray: 0, alpha: opacity)
        }

        if viewSize.equalTo(CGSize.zero) {
            return
        }

        // center hud
        // Draw rounded HUD backgroud rect
        let boxRect = CGRect(x: round((bounds.width - viewSize.width) * 0.5) + xOffset,
                             y: round((bounds.height - viewSize.height) * 0.5) + yOffset, width: viewSize.width, height: viewSize.height)

        let radius = cornerRadius
        context.beginPath()
        context.move(to: CGPoint(x: boxRect.minX + radius, y: boxRect.minY))
        context.addArc(center: CGPoint(x: boxRect.maxX - radius, y: boxRect.minY + radius),
                       radius: radius, startAngle: 3 * .pi * 0.5, endAngle: 0, clockwise: false)
        context.addArc(center: CGPoint(x: boxRect.maxX - radius, y: boxRect.maxY - radius),
                       radius: radius, startAngle: 0, endAngle: .pi * 0.5, clockwise: false)
        context.addArc(center: CGPoint(x: boxRect.minX + radius, y: boxRect.maxY - radius),
                       radius: radius, startAngle: .pi * 0.5, endAngle: .pi, clockwise: false)
        context.addArc(center: CGPoint(x: boxRect.minX + radius, y: boxRect.minY + radius),
                       radius: radius, startAngle: .pi, endAngle: 3 * .pi * 0.5, clockwise: false)
        context.closePath()
        context.fillPath()

        UIGraphicsPopContext()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let parent = superview {
            frame = parent.bounds
        }

        let boundsCenter = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)

        switch mode {
        case .grayIndicator:
            indicator.center = boundsCenter
        case .largeWhiteIndicator:
            indicator.center = boundsCenter
            indicatorAndTextSize()
        case .indicatorAndText, .text:
            indicatorAndTextSize()
        case .rotate:
            rotationView?.center = boundsCenter
        case .progress:
            progressView?.center = boundsCenter
        case .customView:
            if let v = customView {
                v.center = boundsCenter
            }
        case .succeedStatus:
            var suframe = (succeedView?.frame)!
            suframe.origin.x = 30
            suframe.origin.y = (bounds.height - suframe.height)*0.5
            succeedView?.frame = suframe
        }
    }
}

extension ProgressHUD {
    class func showHUDAdded(_ view: UIView, _ aniamted: Bool) -> ProgressHUD {
        let hud = ProgressHUD(frame: view.bounds)
        view.addSubview(hud)
        hud.show(aniamted)
        return hud
    }

    class func hideHUDForView(_ view: UIView, _ animated: Bool) -> Bool {
        guard let hud = HUDForView(view) else {
            return false
        }
        hud.hide(animated)
        return true
    }

    class func hideAllHUDs(_ view: UIView, _ animated: Bool) {
        let huds = allHUDs(view)
        for item in huds {
            item.hide(animated)
        }
    }

    class func allHUDs(_ view: UIView) -> [ProgressHUD] {
        var huds = [ProgressHUD]()
        for item in view.subviews {
            if let subv = item as? ProgressHUD {
                huds.append(subv)
            }
        }
        return huds
    }

    class func HUDForView(_ view: UIView) -> ProgressHUD? {
        for item in view.subviews.enumerated().reversed() {
            if item.element.isKind(of: self.classForCoder()) {
                return item.element as? ProgressHUD
            }
        }
        return nil
    }
}

// hud display
extension ProgressHUD {
    func show(_ animated: Bool) {
        assert(Thread.isMainThread, "ProgressHUD needs to be accessed on the main thread.")
        backgroundColor = UIColor.clear
        showUsingAnimation(animated)
    }

    func showUsingAnimation(_ animated: Bool) {
        // Cancel any scheduled hideDelayed: calls
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        setNeedsDisplay()

        if animated && animationType == .zoomIn {
            transform = rotationTransform.concatenating(CGAffineTransform(scaleX: 0.5, y: 0.5))
        } else if animated && animationType == .zoomOut {
            transform = rotationTransform.concatenating(CGAffineTransform(scaleX: 1.5, y: 1.5))
        }
        showStarted = Date()
        // Fade in
        if animated {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.3)
            alpha = 1
            if animationType == .zoomIn || animationType == .zoomOut {
                transform = rotationTransform
            }
            UIView.commitAnimations()
        } else {
            alpha = 1
        }
    }

    func addSucceedAnimation(_ tip: String) {
        if succeedView != nil {
            succeedView?.titleLabel?.text = tip
            succeedView!.addSucceedAnimation()
        }
    }

    func hideAfterDelay(_ delay: CGFloat, _ animated: Bool) {
        self.perform(#selector(hideDelayed(_:)), with: NSNumber(value: animated), afterDelay: TimeInterval(delay))
    }

    @objc private  func hideDelayed(_ animated: NSNumber) {
        hide(animated.boolValue)
    }

    func hide(_ animated: Bool) {
        assert(Thread.isMainThread, "ProgressHUD needs to be accessed on the main thread.")
        useAnimation = animated
        // If the minShow time is set, calculate how long the hud was shown,
        // and pospone the hiding operation if necessary
        if let started = showStarted {
            if minShowTime > 0.0 && showStarted != nil {
                let interv = CGFloat(Date().timeIntervalSince(started))
                if interv < minShowTime {
                    self.minShowTimer = Timer.scheduledTimer(timeInterval: TimeInterval(minShowTime - interv), target: self,
                                                             selector: #selector(hideUsingAnimation(_:)), userInfo: nil, repeats: false)
                    return
                }
            }
        }
        // ... otherwise hide the HUD immediately
        hideUsingAnimation(animated)
    }

    @objc private func hideUsingAnimation(_ animated: Bool) {
        // Fade out
        if animated && showStarted != nil {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.3)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStop(#selector(animationFinished))

            // 0.02 prevents the hud from passing through touches during the animation the hud will get completely hidden
            // in the done method
            if animationType == .zoomIn {
                transform = rotationTransform.concatenating(CGAffineTransform(scaleX: 1.5, y: 1.5))
            } else if animationType == .zoomOut {
                transform = rotationTransform.concatenating(CGAffineTransform(scaleX: 0.5, y: 0.5))
            }

            alpha = 0.02
            UIView.commitAnimations()
        } else {
            alpha = 0
            done()
        }
        showStarted = nil
    }

    @objc private func animationFinished() {
        done()
    }

    private func done() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        alpha = 0
        removeFromSuperview()
    }
}
