//
//  ViewController.swift
//  AVPlayer
//
//  Created by  user on 2018/4/17.
//  Copyright © 2018年 NG. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func nextaction(_ sender: Any) {
        present(PlayerViewController(nibName: "PlayerViewController", bundle: nil), animated: true, completion: nil)
    }
}

