//
//  HomeVC.swift
//  Weibo
//
//  Created by  user on 2018/6/28.
//  Copyright © 2018年 NG. All rights reserved.
//

import UIKit

class HomeVC: VisitorVC {
    var tableView: UITableView?
    lazy private var listViewModel = WBStatusListViewModel()
    private var isPullup = false

    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenBackBtn()
    }
    
    @objc func loadData() {
        listViewModel.loadStatus(pullup: isPullup) { (shouldRefresh, count) in
            if self.isPullup {
                if count == 0 {
                    self.tableView?.ngFooterLoadedEndPage()
                } else {
                    self.tableView?.ngFooterEndRefreshing()
                }
            }else {
                self.tableView?.ngHeaderEndRefreshing()
            }
            self.isPullup = false

            if shouldRefresh {
                if count != 0 && self.tableView?.ngRefreshFooterView() == nil {
                    self.tableView?.ngFooterRefreshAddTarget(self, action: #selector(self.loadMore))
                }
                self.tableView?.reloadData()
            }
        }
    }


    override func startLoadData() {
        tableView?.ngBeginRefreshing()
    }

    @objc func loadMore()  {
        isPullup = true
        loadData()
    }

    override func setupContentViews() {
        let table = UITableView(frame: CGRect(x: 0, y: 64, width: view.width, height: view.height - 64 - 49), style: .plain)
        view.addSubview(table)
        tableView = table
        tableView?.delegate = self
        tableView?.dataSource = self

        tableView?.ngHeaderRefreshAddTarget(self, action: #selector(loadData))

        tableView?.register(cellType: StatusNormalCell.self)
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        tableView?.separatorStyle = .none


        //        HttpsRequest.request(para: RequestParameter(method: .get, url: "https://api.weibo.com/2/emotions.json", parameter: nil), succeed: { (result) in
        //            printLog(result)
        //        }, failed: nil)
    }
}


extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = listViewModel.statusList[indexPath.row]
        return model.layout.rowHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = listViewModel.statusList[indexPath.row]
        let cell = tableView.dequeueReusableCell(for: indexPath) as StatusNormalCell
        cell.setStatus(model)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

