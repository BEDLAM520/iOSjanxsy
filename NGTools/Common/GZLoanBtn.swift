//
//  GZLoanBtn.swift
//  Loan123
//
//  Created by Jason on 2016/12/30.
//  Copyright © 2016年 Jason. All rights reserved.
//

import UIKit

class GZLoanBtn: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setBtnType(backgrondColor: .white,textColor: XEB_BUTTON_COLOR)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setBtnType(backgrondColor: .white,textColor: XEB_BUTTON_COLOR)
    }

}


extension GZLoanBtn {
    
    func setBtnType(backgrondColor:UIColor,textColor:UIColor) {
        self.backgroundColor = backgrondColor
        layer.cornerRadius = 5
        layer.masksToBounds = true
        layer.borderWidth = 1.5
        layer.borderColor = XEB_BUTTON_COLOR.cgColor
        self.setTitleColor(textColor, for: .normal)
    }
    
    
    
}
