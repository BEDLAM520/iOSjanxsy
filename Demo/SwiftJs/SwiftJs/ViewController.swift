//
//  ViewController.swift
//  SwiftJs
//
//  Created by  user on 2018/6/13.
//  Copyright © 2018年 NG. All rights reserved.
//

import UIKit
import JavaScriptCore

class ViewController: UIViewController, UIWebViewDelegate {

    let webView = UIWebView()
    var swiftClosure:(@convention(block) (String, String) -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.frame = view.bounds
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.sizeToFit()
        view.addSubview(webView)

//        guard let htmlurl = Bundle.main.url(forResource: "index.html", withExtension: nil) else {
//            return
//        }
        guard let htmlurl = URL(string: "http://192.168.0.126") else {
            return
        }
        let request = URLRequest(url: htmlurl)
        webView.loadRequest(request)

        let btn = UIButton(frame: CGRect(x: 200, y: 300, width: 50, height: 50))
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(test), for: .touchUpInside)
        view.addSubview(btn)
    }

    @objc func test() {
        print("---")
        webView.stringByEvaluatingJavaScript(from: "updateOcr()")
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("-----11")
        guard let context = self.webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext else {
            return
        }

        let willCallClosure = {
            (_ url: String, _ title: String) -> Void
            in
            print(url)
            print(title)
        }

        swiftClosure = willCallClosure
        context.setObject(unsafeBitCast(swiftClosure, to: AnyObject.self), forKeyedSubscript: "getLocation" as NSCopying & NSObjectProtocol)
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error.localizedDescription)
    }
}

