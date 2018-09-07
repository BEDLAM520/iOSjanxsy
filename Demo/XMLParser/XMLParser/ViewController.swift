//
//  ViewController.swift
//  XMLParser
//
//  Created by user on 2017/6/6.
//  Copyright © 2017年 user. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate let urlStr = "http://www.apple.com/main/rss/hotnews/hotnews.rss"
    fileprivate var cellStates: [StateCellState]?
    fileprivate var dataArray: [(title: String, pubDate: String, description: String)]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        
        let parser = XMLParserManager()
        parser.requestData(urlStr: urlStr) {[weak self] (dataArray) in
            self?.dataArray = dataArray
            self?.cellStates = Array(repeating: .CloseState, count: dataArray.count)
                
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        }
    }
    
    
    
}


extension ViewController:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let array = self.dataArray else {
            return 0
        }
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StateTableViewCell
        
        let item = dataArray?[indexPath.row]
        (cell.titleLabel.text, cell.dateLabel.text, cell.descLabel.text) = (item?.title,item?.pubDate,item?.description)
        
        if let state = cellStates?[indexPath.row] {
            cell.descLabel.numberOfLines = state == .CloseState ? 4 : 0
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! StateTableViewCell
        
        
        ///  想要做出只改变一个子视图的效果，不要设置hugging compression这些约束
        tableView.beginUpdates()
        cell.descLabel.numberOfLines = cell.descLabel.numberOfLines == 4 ? 0 : 4
        cellStates?[indexPath.row] = cell.descLabel.numberOfLines == 0 ? .OpenState : .CloseState
        tableView.endUpdates()
    }
}
