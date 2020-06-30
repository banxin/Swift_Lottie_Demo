//
//  HPCRefreshHeader.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/6/14.
//  Copyright © 2019 颜浪. All rights reserved.
//

import UIKit

/// 基础下拉刷新控件: 负责监控用户下拉的状态
open class HPCRefreshHeader: HPCRefreshComponent {
    
    /// 插入的偏移量
    private var insertDelta: CGFloat = 0.0
    /// 这个Key用来存储上一次下拉刷新成功的时间
    var lastUpdatedTimeKey: String = HPCRefreshConst.headerLastUpdatedTimeKey
    
    // MARK: - Set & Get
    
    /// 上一次下拉刷新成功的时间
    public var lastUpdatedTime: Date? {
        return UserDefaults.standard.object(forKey: self.lastUpdatedTimeKey) as? Date
    }
    
    /// 忽略多少scrollView的contentInset的top
    public var ignoredScrollViewContentInsetTop: CGFloat = 0.0 {
        didSet {
            self.hpc_y = -self.hpc_h - ignoredScrollViewContentInsetTop
        }
    }
    
    // MARK: - override
    
    override open var state: HPCRefreshState {
        get {
            return super.state
        }
        set {
            /// check state, 相同的state 直接return
            guard let oldState = check(newState: newValue, oldState: state), let indeedScrollView = self.scrollView else { return }
            super.state = newValue
            /// 更具状态做事情
            if newValue == .idle {
                if oldState != .refreshing { return }
                /// save
                UserDefaults.standard.setValue(Date(), forKey: self.lastUpdatedTimeKey)
                UserDefaults.standard.synchronize()
                /// 恢复inset和offSet
                UIView.animate(withDuration: HPCRefreshConst.slowAnimateDuration, animations: {
                    indeedScrollView.hpc_insetT += self.insertDelta
                    /// 自动调整透明度
                    if self.automaticallyChangeAlpha { self.alpha = 0.0 }
                }) { (finished) in
                    self.pullingPercent = 0.0
                    /// 回调block
                    if let block = self.endRefreshingCompletionClosure {
                        block()
                    }
                }
            } else if newValue == .refreshing {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: HPCRefreshConst.fastAnimateDuration, animations: {
                        let top = self.scrollViewOriginalInset.top + self.hpc_h
                        /// 增加滚动区域top
                        indeedScrollView.hpc_insetT = top
                        /// 设置滚动位置
                        var offset = indeedScrollView.contentOffset
                        offset.y = -top
                        indeedScrollView.setContentOffset(offset, animated: false)
                    }) { (finished) in
                        /// 回调正在刷新的block
                        self.executeRefreshingClosure()
                    }
                }
            }
        }
    }
    
    override open func prepare() {
        super.prepare()
        self.hpc_h =  HPCRefreshConst.headerHeight
    }
    
    override open func placeSubViews() {
        super.placeSubViews()
        /// 设置y值(当自己的高度发生改变了, 肯定要重新调整y值, 所以放到placeSubViews中调整y值)
        self.hpc_y = -self.hpc_h - self.ignoredScrollViewContentInsetTop
    }
    
    override open func scrollViewContentOffsetDid(change: [NSKeyValueChangeKey: Any]) {
        super.scrollViewContentOffsetDid(change: change)
        guard let indeedScrollView = self.scrollView else { return }
        /// 在刷新的状态
        if self.state == .refreshing {
            /// 暂时保留
            /// 可能会导致问题
            if self.window == nil { return }
            /// sectionHeader停留解决, 计算应该偏移的位置 重点
            var inserT = -indeedScrollView.hpc_offsetY > _scrollViewOriginalInset.top ? -indeedScrollView.hpc_offsetY : _scrollViewOriginalInset.top
            inserT = inserT > self.hpc_h + _scrollViewOriginalInset.top ? self.hpc_h + _scrollViewOriginalInset.top : inserT
            indeedScrollView.hpc_insetT = inserT
            self.insertDelta = _scrollViewOriginalInset.top - inserT
            return
        }
        /// 跳转到下一个控制器时, contentInset可能会变
        _scrollViewOriginalInset = indeedScrollView.hpc_inset
        /// 当前的contentOffset
        let offsetY = indeedScrollView.hpc_offsetY
        /// 头部控件刚好出现的offsetY
        let happenOffsetY = -self.scrollViewOriginalInset.top
        /// 如果向上滚动到看不见头部控件, 直接返回
        if  offsetY > happenOffsetY { return }
        /// 普通和即将刷新 的临界点
        /** 偏移量加上自身的高度 */
        let normalpullingOffsetY = happenOffsetY - self.hpc_h
        let pullingPercent = (happenOffsetY - offsetY) / self.hpc_h
        /// 如果正在拖拽
        if indeedScrollView.isDragging {
            self.pullingPercent = pullingPercent
            if self.state == .idle && offsetY < normalpullingOffsetY {
                /// 转换为即将刷新状态
                self.state = .pulling
            } else if self.state == .pulling && offsetY >= normalpullingOffsetY {
                /// 转换为普通状态
                self.state = .idle
            }
        } else if self.state == .pulling {
            /// 即将刷新 && 手松开
            self.beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
}

// MARK: - 构造函数
extension HPCRefreshHeader {
    
    /// 遍历构造函数(下拉回调)
    ///
    /// - Parameter closure: 下拉刷新 回调 closure
    public convenience init(headerWithRefreshing closure: @escaping HPCRefreshComponentRefreshingClosure) {
        
        self.init()
        
        refreshingClosure = closure
    }
    
    /// 类方法, 快速的创建带有正在刷新回调的下拉刷新控件
    public static func headerWithRefreshing(closure: @escaping HPCRefreshComponentRefreshingClosure) -> HPCRefreshHeader {
        let header = self.init()
        header.refreshingClosure = closure
        return header
    }
    
//    /// 遍历构造函数（target 和 action）
//    ///
//    /// - Parameters:
//    ///   - target: target
//    ///   - action: action
//    public convenience init(headerWithRefreshing target: AnyObject, action: Selector) {
//        
//        self.init()
//        
//        self.setRefreshing(target: target, action: action)
//    }
}
