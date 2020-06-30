//
//  HPCRefreshFooter.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/6/14.
//  Copyright © 2019 颜浪. All rights reserved.
//

import UIKit

/// 上拉加载更多
open class HPCRefreshFooter: HPCRefreshComponent {
    
    /// 忽略scrollView contentInset的bottom
    public var ignoredScrollViewContentInsetBottom: CGFloat = 0.0
    
    // MARK: - override
    
    override open func prepare() {
        super.prepare()
        /// 设置高度
        self.hpc_h = HPCRefreshConst.footerHeight
    }
}

// MARK: - public method
extension HPCRefreshFooter {
    
    /// 提示没有更多数据
    public func endRefreshingWithNoMoreData() {
        DispatchQueue.main.async {
            self.state = .noMoreData
        }
    }
    
    /// 重置没有更多数据
    public func resetNoMoreData() {
        DispatchQueue.main.async {
            self.state = .idle
        }
    }
}

// MARK: - 构造函数
extension HPCRefreshFooter {
    
    /// 遍历构造函数(上拉回调)
    ///
    /// - Parameter closure: 下拉刷新 回调 closure
    public convenience init(footerWithRefreshing closure: @escaping HPCRefreshComponentRefreshingClosure) {
        
        self.init()
        
        refreshingClosure = closure
    }
    
//    /// 遍历构造函数（target 和 action）
//    ///
//    /// - Parameters:
//    ///   - target: target
//    ///   - action: action
//    public convenience init(footerWithRefreshing target: AnyObject, action: Selector) {
//
//        self.init()
//
//        self.setRefreshing(target: target, action: action)
//    }
}
