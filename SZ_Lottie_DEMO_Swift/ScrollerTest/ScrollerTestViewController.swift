//
//  ScrollerTestViewController.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/7/4.
//  Copyright © 2019 颜浪. All rights reserved.
//

import Then
import Lottie
import SnapKit
import RxSwift
import RxCocoa

private let cellId = "cellId"

/// 上拉和下拉的动画
class ScrollerTestViewController: UIViewController {
    
    private var headTop: UIView = UIView().then {
        
        $0.backgroundColor = UIColor.colorWithHex(hexString: "ff0000").withAlphaComponent(0.5)
    }
    
    private var headMiddle: UIView = UIView().then {
        
        $0.backgroundColor = UIColor.colorWithHex(hexString: "0000ff")
    }
    
    private var headBottom: UIView = UIView().then {
        
        $0.backgroundColor = UIColor.colorWithHex(hexString: "ff00ff")
    }
    
    private var cellCount: Int = 20
    
    private let tableView: UITableView = UITableView().then {
        
//        $0.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.contentInset = UIEdgeInsets(top: 180 + 40 + 40, left: 0, bottom: 0, right: 0)
        $0.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        $0.tableFooterView = UIView.init()
    }
    
    private let bag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        refreshView()
    }
}

// MARK: - UI
extension ScrollerTestViewController {
    
    private func setupUI() {
        
        view.backgroundColor = UIColor.colorWithHex(hexString: "f8f8f8")
        
        title = "TaoBaoResultList Demo"
        
        // 重置 变为不透明
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        edgesForExtendedLayout = UIRectEdge.bottom
        
        setupTableView()
        setupTopView()
    }
    
    private func setupTableView() {
        
        tableView.backgroundColor = UIColor.colorWithHex(hexString: "f8f8f8")
        tableView.dataSource = self
        tableView.delegate   = self
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
//        tableView.hpc_header = HPCRefreshLottieHeader(headerWithRefreshing: { [weak self] in
//
//            self?.refreshData()
//        })
        
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
    
    private func setupTopView() {
        
        let l1 = UILabel().then {
            
            $0.textAlignment = .center
            $0.text          = "This is Tab~"
            $0.font = UIFont.systemFont(ofSize: 15)
        }
        
        let l2 = UILabel().then {
            
            $0.textAlignment = .center
            $0.text          = "This is Banner~"
            $0.font = UIFont.systemFont(ofSize: 15)
        }
        
        let l3 = UILabel().then {
            
            $0.textAlignment = .center
            $0.text          = "This is Sort~"
            $0.font = UIFont.systemFont(ofSize: 15)
        }
        
        headTop.addSubview(l1)
        headMiddle.addSubview(l2)
        headBottom.addSubview(l3)
        
        l1.snp.makeConstraints { (maker) in
            
            maker.edges.equalToSuperview()
        }
        
        l2.snp.makeConstraints { (maker) in
            
            maker.edges.equalToSuperview()
        }
        
        l3.snp.makeConstraints { (maker) in
            
            maker.edges.equalToSuperview()
        }
        
        view.addSubview(headMiddle)
        view.addSubview(headTop)
        view.addSubview(headBottom)
        
        headTop.snp.makeConstraints { (maker) in
            
            maker.left.right.top.equalToSuperview()
            maker.height.equalTo(40)
        }
        
        headMiddle.snp.makeConstraints { (maker) in
            
            maker.left.right.equalToSuperview()
            maker.top.equalTo(40)
            maker.height.equalTo(180)
        }
        
        headBottom.snp.makeConstraints { (maker) in
            
//            maker.top.equalTo(self.headMiddle.snp.bottom)
            maker.top.equalTo(40 + 180)
            maker.left.right.equalToSuperview()
            maker.height.equalTo(40)
        }
        
//        tableView.rx.observe(CGPoint.self, "contentOffset").subscribe(onNext: { (point) in
//
//            if let p = point {
//
//                print("oldValue: \(p)")
//            }
//
//        }).disposed(by: bag)
    }
    
    private func refreshView() {
        
        tableView.reloadData()
        tableView.setContentOffset(CGPoint(x: 0, y: -180 - 40 - 40), animated: false)
    }
}

// MARK: - UITableViewDataSource
extension ScrollerTestViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell?.textLabel?.text = "TaoBaoResultList Test: \(indexPath.row)"
        
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension ScrollerTestViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ScrollerTestViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 0 {
            
            // contentOffset.y 的绝对值
            let absY = abs(scrollView.contentOffset.y)
            
            // 180 + 40 + 40 topOffset
            let height: CGFloat = 180 + 40 + 40
            
            // table总的offsetTop - contentOffset.y的绝对值，计算一个偏移量
            let offset = height - absY
            
            headTop.snp.updateConstraints { (maker) in
                
                // contentOffset.y
                let scrollerY = scrollView.contentOffset.y
                
                // headTop 原本的 y
                let originTop: CGFloat = 0
                
                // 新的 y
                var newTop: CGFloat = 0
                
                // 只需要在该范围内做上下平移处理
                if scrollerY >= -80 && scrollerY <= -40 {

                    // -80 对应 0
                    // -40 对应 -40
                    // 用 80 - contentOffset.y的绝对值，然后取反
                    newTop = -(80 - absY)

                } else {
                    
                    newTop = scrollerY > -40 ? -40 : originTop
                }
                
//                print("headTop--y: \(scrollView.contentOffset.y)~~~")
//                print("headTop--offset: \(offset)~~~")
//                print("headTop--newTopOffset: \(newTop)~~~")
                maker.top.equalTo(newTop)
            }
            
            headMiddle.snp.updateConstraints { (maker) in
                
                // headMiddle 原本的 y
                let originTop: CGFloat = 40
                // 新的 y
                var newTop: CGFloat    = 0
                
                // 当 offset 小于 originTop
                if offset <= originTop {
                    
                    // 当 offset 的绝对值 大于 原本的y
                    if abs(offset) > originTop {
                        
                        // 使用原本的y
                        newTop = originTop
                        
                        // 当 offset 的绝对值 小于 原本的y
                    } else {
                        
                        // 如果 offset 小于 0，则使用 originTop，否则 用原本的y 减去offset的绝对值
                        newTop = offset < 0 ? originTop : originTop - abs(offset)
                    }
                    
                    // 当 offset 大于 originTop
                } else {
                    
                    // 使用 offset 的取反 加上 原本的originTop
                    newTop = -offset + originTop
                }
                
//                print("headMiddle--y: \(absY)~~~")
//                print("headMiddle--offset: \(offset)~~~")
//                print("headMiddle--newTopOffset: \(newTop)~~~")
                maker.top.equalTo(newTop)
            }
            
            headBottom.snp.updateConstraints { (maker) in
                
                // headTop 原本的 y
                let originTop: CGFloat = 220
                // 新的 y（ 0 即为 吸顶）
                var newTop: CGFloat    = 0
                
                // 当 offset 小于 originTop
                if offset <= originTop {
                    
                    // 当 offset 的绝对值 大于 原本的y
                    if abs(offset) > originTop {
                        
                        // 使用原本的y
                        newTop = originTop
                        
                        // 当 offset 的绝对值 小于 原本的y
                    } else {
                        
                        // 如果 offset 小于 0，则使用 originTop，否则 用原本的y 减去offset的绝对值
                        newTop = offset < 0 ? originTop : originTop - abs(offset)
                    }
                }
                
//                print("headBottom--y: \(scrollView.contentOffset.y)~~~")
//                print("headBottom--offset: \(offset)~~~")
//                print("headBottom--newTopOffset: \(newTop)~~~")
                maker.top.equalTo(newTop)
            }
        }
    }
}

// MARK: - private method
extension ScrollerTestViewController {
    
    private func refreshData() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(floatLiteral: 1.0)) {
            
            self.cellCount = 20
            self.tableView.hpc_header?.endRefreshing()
            self.tableView.hpc_footer?.endRefreshing()
            
            self.tableView.reloadData()
        }
    }
    
    private func loadMoreData() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(floatLiteral: 1.0)) {
            
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
