//
//  UIScrollView+Extensions.swift
//  ECWallet
//
//  Created by  user on 2018/2/1.
//  Copyright © 2018年 ECW. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    func scrollToTop() {
        var off = self.contentOffset
        off.y = 0 - self.contentInset.top
        self.setContentOffset(off, animated: true)
    }

    func scrollToBottom() {
        var off = self.contentOffset
        off.y = self.contentSize.height - self.bounds.height + self.contentInset.bottom
        self.setContentOffset(off, animated: true)
    }

    func scrollToLeft() {
        var off = self.contentOffset
        off.x = 0 - self.contentInset.left
        self.setContentOffset(off, animated: true)
    }

    func scrollToRight() {
        var off = self.contentOffset
        off.x = self.contentSize.width - self.bounds.width + self.contentInset.right
        self.setContentOffset(off, animated: true)
    }

    func neverAdjustsScrollViewInsets() {
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
    }
}

/// 键值观察器类，使用UIView是为了持有，所以在使用该功能时，在ScrollView删除子试图需要注意
private class KeyValueObserContentView: UIView {
    public var keyValueObservations = [NSKeyValueObservation]()
    deinit {
        for item in keyValueObservations {
            item.invalidate()
        }
        keyValueObservations.removeAll()
    }
}

extension UIScrollView {

    /// UIScrollView偏移观察
    ///
    /// - Parameter closure: 在偏移中所做的操作
    func observeContentOffset(_ closure: @escaping () -> Void) {
        let contentView = getContentView()
        addSubview(contentView)
        let keyValueObservation = observe(\.contentOffset, options: [.new, .old]) {_, _ in
            closure()
        }
        contentView.keyValueObservations.append(keyValueObservation)
    }

    func observeContentSize(_ closure: @escaping () -> Void) {
        let contentView = getContentView()
        addSubview(contentView)
        let keyValueObservation = observe(\.contentSize, options: [.new, .old]) {_, _ in
            closure()
            //            print(change.newValue)
        }
        contentView.keyValueObservations.append(keyValueObservation)
    }

    private func getContentView() -> KeyValueObserContentView {
        for item in subviews {
            if let view = item as? KeyValueObserContentView {
                return view
            }
        }
        return KeyValueObserContentView()
    }
}
