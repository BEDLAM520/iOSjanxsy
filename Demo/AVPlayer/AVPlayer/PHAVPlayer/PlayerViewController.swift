//
//  PlayerViewController.swift
//  AVPlayer
//
//  Created by  user on 2018/4/17.
//  Copyright © 2018年 NG. All rights reserved.
//

import UIKit


//RVideoPlayer

class PlayerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let source = "https://mvvideo5.meitudata.com/56ea0e90d6cb2653.mp4"
        //        let source = "https://gslb.miaopai.com/stream/nhb~60BbxpZjiEjBtJcheQ__.mp4?ssig=fe032a741445834062e251d47a2724ec&time_stamp=1531136236372&cookie_id=&vend=1&os=3&partner=1&platform=2&cookie_id=&refer=miaopai&scid=nhb%7E60BbxpZjiEjBtJcheQ__"
        let urlStr = source

        let playerview = AVPlayerOperationView(frame: CGRect(x: 0, y: 50, width: view.width, height: view.width * 0.5), urlString: urlStr)
        playerview.backgroundColor = UIColor.yellow
        view.addSubview(playerview)
        
        let btn = UIButton(frame: CGRect(x: 100, y: 400, width: 40, height: 40))
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(goback), for: .touchUpInside)
        view.addSubview(btn)
    }

   @objc func goback() {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        printLog(self)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}


