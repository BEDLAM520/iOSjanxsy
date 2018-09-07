//
//  StateTableViewCell.swift
//  XMLParser
//
//  Created by user on 2017/6/6.
//  Copyright © 2017年 user. All rights reserved.
//

import UIKit

enum StateCellState {
    case OpenState
    case CloseState
}

class StateTableViewCell: UITableViewCell {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
