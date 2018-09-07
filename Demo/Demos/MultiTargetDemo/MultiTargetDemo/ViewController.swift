//
//  ViewController.swift
//  MultiTargetDemo
//
//  Created by  user on 2018/1/18.
//  Copyright © 2018年 NG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        #if MULITARGETDEMOFLAG
            print("flag")
        #else
            print("targ")
        #endif
        
        #if DEBUG
            print("debug")
        #else
            print("No")
        #endif
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

