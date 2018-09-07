//
//  VisitorView.swift
//  Weibo
//
//  Created by  user on 2018/6/28.
//  Copyright © 2018年 NG. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func startAnimation() {

        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2.0 * .pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 15

        // 循环播放，动画完成不删除
        anim.isRemovedOnCompletion = false
        // 将动画添加到图层，但控件被销毁，动画也会一起被销毁
        iconView.layer.add(anim, forKey: nil)
    }


    var visitorInfo: [String: String]? {
        didSet {

            guard let imageName = visitorInfo?["imageName"],
                let mesage = visitorInfo?["message"] else {
                    return
            }

            tipLabel.text = mesage

            if imageName == "" {
                startAnimation()
                return
            }

            iconView.image = UIImage(named: imageName)

            houseIconView.isHidden = true
            maskIconView.isHidden = true
        }
    }

    lazy fileprivate var iconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))

    lazy var maskIconView: UIImageView = UIImageView(image: UIImage(named:"visitordiscover_feed_mask_smallicon"))

    lazy var houseIconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    lazy var tipLabel: UILabel = { ()->UILabel in
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0;
        return label
    }()


    lazy var registerButton: UIButton = {()->UIButton in
        let btn = UIButton()
        btn.setTitle("注册", for: .normal)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.setTitleColor(UIColor.black, for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), for: .normal)
        return btn
    }()

    lazy var loginButton: UIButton = {()->UIButton in
        let btn = UIButton()
        btn.setTitle("登录", for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.setTitleColor(UIColor.black, for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), for: .normal)
        return btn
    }()

}

extension VisitorView {

    func setupViews() {
        backgroundColor = UIColor.ColorHex(hex: "ededed")

        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLabel)
        addSubview(registerButton)
        addSubview(loginButton)

        // 取消  autoresizing
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }

        let margin: CGFloat = 20.0


        //
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -60))
        //
        addConstraint(NSLayoutConstraint(item: houseIconView, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: houseIconView, attribute: .centerY, relatedBy: .equal, toItem: iconView, attribute: .centerY, multiplier: 1.0, constant: 0))

        //
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .top, relatedBy: .equal, toItem: iconView, attribute: .bottom, multiplier: 1.0, constant: margin))
        addConstraint(NSLayoutConstraint(item: tipLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 236))


        //  因为没有设置按钮的高度，所以切片时 Slicing时设置水平拉伸
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .left, relatedBy: .equal, toItem: tipLabel, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .top, relatedBy: .equal, toItem: tipLabel, attribute: .bottom, multiplier: 1.0, constant: margin))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100))

        //  因为没有设置按钮的高度，所以切片时 Slicing时设置水平拉伸
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .right, relatedBy: .equal, toItem: tipLabel, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: registerButton, attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: .width, relatedBy: .equal, toItem: registerButton, attribute: .width, multiplier: 1.0, constant: 0))



        // views: 定义 VFL 中的控件名称和实际名称映射关系
        // metrics: 定义 VFL 中（）指定的常数影射关系
        // 如果崩溃看有没有添加到父视图上
        let viewDict = ["maskIconView": maskIconView,
                        "registerButton": registerButton] as [String : UIView]
        let metrics = ["spacing": -20];
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[maskIconView]-0-|", options: [], metrics: nil, views: viewDict))

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[maskIconView]-(spacing)-[registerButton]", options: [], metrics: metrics, views: viewDict))
    }
}
