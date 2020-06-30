//
//  RefreshViewController.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/5/27.
//  Copyright © 2019 颜浪. All rights reserved.
//

import UIKit

import Then
import Lottie
import SnapKit
import RxSwift
import RxCocoa

private let cellId = "cellId"

/// 上拉和下拉的动画
class RefreshViewController: UIViewController {
    
    private var cellCount: Int = 20
    
    private let tableView: UITableView = UITableView().then {
        
        $0.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        $0.tableFooterView = UIView.init()
    }
    
    private let bag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
    }
}

// MARK: - UI
extension RefreshViewController {
    
    private func setupUI() {
        
        view.backgroundColor = UIColor.colorWithHex(hexString: "f8f8f8")
        
        title = "Refresh Demo"
        
        setupTableView()
    }
    
    private func setupTableView() {
        
//        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.backgroundColor = UIColor.colorWithHex(hexString: "f8f8f8")
        tableView.dataSource = self
        tableView.delegate   = self
        
        tableView.hpc_header = HPCRefreshLottieHeader(headerWithRefreshing: { [weak self] in
            
            self?.refreshData()
        })

        tableView.hpc_footer = HPCRefreshLottieFooter(footerWithRefreshing: { [weak self] in

            self?.loadMoreData()
        })
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (maker) in
            
            if #available(iOS 11.0, *) {

                maker.bottom.equalTo(self.view.safeAreaLayoutGuide)
                maker.top.left.right.equalToSuperview()

            } else {

                maker.edges.equalToSuperview()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension RefreshViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell?.textLabel?.text = "Refresh Test: \(indexPath.row)"
        
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension RefreshViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - private method
extension RefreshViewController {
    
    private func refreshData() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(floatLiteral: 2.0)) {
            
            self.cellCount = 20
            self.tableView.hpc_header?.endRefreshing()
            self.tableView.hpc_footer?.endRefreshing()
            
            self.tableView.reloadData()
        }
    }
    
    private func loadMoreData() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(floatLiteral: 2.0)) {
            
            self.cellCount += 10
            
            if self.cellCount > 40 {
                
                self.tableView.hpc_footer?.endRefreshingWithNoMoreData()
                
            } else {
                
                self.tableView.hpc_footer?.endRefreshing()
            }
            
            self.tableView.reloadData()
        }
    }
}
