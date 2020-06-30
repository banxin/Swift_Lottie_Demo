//
//  HPCRefreshAutoFooter.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/6/14.
//  Copyright © 2019 颜浪. All rights reserved.
//

import UIKit

/// 会自动刷新的上拉刷新控件
open class HPCRefreshAutoFooter: HPCRefreshFooter {
    
    // MARK: - public property
    
    /// 是否自动刷新, 默认是`true`
    public var automaticallyRefresh: Bool = true
    /// 当底部控件出现多少时就自动刷新(默认为1.0 也就是底部控件完全出现时, 才会自动刷新)
    public var triggerAutomaticallyRefreshPercent: CGFloat = 1.0
    /// 是否每次拖拽一次只发一次请求, 默认是`false`
    public var onlyRefreshPerDray: Bool = false
    
    // MARK: - private property
    
    /// 一个新的拖拽事件
    private var oneNewPan: Bool?
    
    // MARK: - init
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let indeedScrollView = self.scrollView else { return }
        /// 新的父控件
        if let _ = newSuperview {
            if !self.isHidden {
                indeedScrollView.hpc_insetB += self.hpc_h
            }
            /// 设置位置
            self.hpc_y = indeedScrollView.hpc_contentH
        } else {
            /// 被移除
            if !self.isHidden {
                /// 恢复到原始状态
                indeedScrollView.hpc_insetB -= self.hpc_h
            }
        }
    }
    
    // MARK: - override
    
    override open func prepare() {
        super.prepare()
        /// 默认底部控件100%出现时才会自动刷新
        self.triggerAutomaticallyRefreshPercent = 1.0
        self.automaticallyRefresh = true
        /// 默认是offSet达到条件就发送请求(可连续)
        self.onlyRefreshPerDray = false
    }
    
    override open func scrollViewContentSizeDid(change: [NSKeyValueChangeKey: Any]?) {
        
        super.scrollViewContentSizeDid(change: change)
        
        /// 设置位置
        guard let indeedScrollView = self.scrollView else { return }
        
        self.hpc_y = indeedScrollView.hpc_contentH
    }
    
    override open func scrollViewContentOffsetDid(change: [NSKeyValueChangeKey: Any]) {
        
        super.scrollViewContentOffsetDid(change: change)
        
        guard let indeedScrollView = self.scrollView else { return }
        
        if self.state != .idle || !self.automaticallyRefresh || self.hpc_y == 0 { return }
        
        /// 内容超过一个屏幕
        if indeedScrollView.hpc_insetT + indeedScrollView.hpc_contentH > indeedScrollView.hpc_contentH {
            let condition = indeedScrollView.hpc_offsetY >= indeedScrollView.hpc_contentH - indeedScrollView.hpc_h + self.hpc_h * self.triggerAutomaticallyRefreshPercent + indeedScrollView.hpc_insetB - self.hpc_h
            if condition {
                if let old = change[.oldKey] as? CGPoint, let new = change[.newKey] as? CGPoint {
                    if new.y <= old.y { return }
                    /// 当底部刷新控件完全显示时 才刷新
                    self.beginRefreshing()
                }
            }
        }
    }
    
    override open func scrollViewPanStateDid(change: [NSKeyValueChangeKey: Any]) {
        
        super.scrollViewPanStateDid(change: change)
        
        guard let indeedScrollView = self.scrollView else { return }
        
        if self.state != .idle { return }
        
        let state = indeedScrollView.panGestureRecognizer.state
        
        /// 手松开
        if state == .ended {
            /// 不够一个屏幕
            if indeedScrollView.hpc_insetT + indeedScrollView.hpc_contentH <= indeedScrollView.hpc_h {
                /// 向上拽
                if indeedScrollView.hpc_offsetY >= -indeedScrollView.hpc_insetT {
                    self.beginRefreshing()
                }
            } else {
                /// 超出一个屏幕
                if indeedScrollView.hpc_offsetY >= indeedScrollView.hpc_contentH + indeedScrollView.hpc_insetB - indeedScrollView.hpc_h {
                    self.beginRefreshing()
                }
            }
        } else if state == .began {
            self.oneNewPan = true
        }
    }
    
    override public func beginRefreshing() {
        
        guard let newPan = self.oneNewPan else { return }
        
        if !newPan && self.onlyRefreshPerDray { return }
        
        super.beginRefreshing()
        
        self.oneNewPan = false
    }
    
    override open var state: HPCRefreshState {
        get {
            return super.state
        }
        set {
            guard let oldState = check(newState: newValue, oldState: state) else { return }
            super.state = newValue
            if newValue == .refreshing {
                self.executeRefreshingClosure()
            } else if newValue == .noMoreData || newValue == .idle {
                if oldState == .refreshing {
                    if let endRefreshClosure = self.endRefreshingCompletionClosure {
                        endRefreshClosure()
                    }
                }
            }
        }
    }
    
    override open var isHidden: Bool {
        didSet {
            guard let indeedScrollView = self.scrollView else { return }
            if isHidden && !oldValue {
                self.state = .idle
                indeedScrollView.hpc_insetB -= self.hpc_h
            } else if !isHidden && oldValue {
                indeedScrollView.hpc_insetB += self.hpc_h
                /// 设置位置
                self.hpc_y = indeedScrollView.hpc_contentH
            }
        }
    }
}
