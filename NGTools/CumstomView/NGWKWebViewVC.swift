//
//  NGWKWebViewVC.swift
//

import UIKit
import WebKit
//import SVProgressHUD

class NGWKWebViewVC: NGOpaqueBarViewController {

    fileprivate let webView = WKWebView()
    fileprivate let progressView = UIProgressView()
    var urlStr:String?
    fileprivate var haveBeRequest = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        guard let urlString = urlStr ,
        let url = URL(string: urlString)
         else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
           progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress == 1 {
                UIView.animate(withDuration: 0.5, animations: { 
                    self.progressView.alpha = 0
                })
            }
        }
    }
}

extension NGWKWebViewVC{
    fileprivate func setupViews(){
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.scrollView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        view.addSubview(webView)
        view.addmoreEqualConstrain(item: webView, toItem: view, attribute: .top,.left,.bottom,.right)
        
        
        progressView.frame = CGRect(x: 0, y: 64, width: view.width, height: 100)
        progressView.progressTintColor = RGBA(79, 195, 38, 1)
        progressView.trackTintColor = UIColor.clear
        progressView.progress = 0;
        view.addSubview(progressView)
        
    }
}

extension NGWKWebViewVC: WKNavigationDelegate,WKUIDelegate{
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        title = webView.title
//    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        haveBeRequest = true
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        progressView.alpha = 0
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.alpha = 0
        if haveBeRequest == false {
//           SVProgressHUD.show(nil, status: "链接超时！")
        }
        haveBeRequest = true
    }
}
