//
//  HPCRefreshComponent.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/6/14.
//  Copyright © 2019 颜浪. All rights reserved.
//

import UIKit

/// 刷新控件的状态
///
/// - idle:        普通闲置状态
/// - pulling:     松开就可以进行刷新的状态
/// - refreshing:  正在刷新中的状态
/// - willRefresh: 即将刷新的状态
/// - nomoreData:  所有数据加载完毕, 没有更多的数据了
public enum HPCRefreshState {
    case idle
    case pulling
    case refreshing
    case willRefresh
    case noMoreData
}

/// 进入刷新状态的回调
public typealias HPCRefreshComponentRefreshingClosure = () -> Void
/// 开始刷新后的回调(进入刷新状态后的回调)
public typealias HPCRefreshComponentbeiginRefreshingCompletionClosure = () -> Void
/// 结束刷新后的回调
public typealias HPCRefreshComponentEndRefreshingCompletionClosure = () -> Void

/// 刷新控件的基类
open class HPCRefreshComponent: UIView {
    
    /// 记录scrollView刚开始的inset
    var _scrollViewOriginalInset: UIEdgeInsets = UIEdgeInsets.zero
    
    /// 父控件
    private weak var _scrollView: UIScrollView? {
        didSet {
            /// 初始化状态
            self.state = .idle
        }
    }
    
    /// 正在刷新的回调
    public var refreshingClosure: HPCRefreshComponentRefreshingClosure?
    /// 开始刷新后的回调(进入刷新状态后的回调)
    public var beginRefreshingCompletionClosure: HPCRefreshComponentbeiginRefreshingCompletionClosure?
    /// 结束刷新的回调
    public var endRefreshingCompletionClosure: HPCRefreshComponentEndRefreshingCompletionClosure?
    
    /// 手势
    var pan: UIPanGestureRecognizer?
    
    // MARK: - 交给子类去访问
    
    /// 记录scrollView刚开始的inset, readonly
    public var scrollViewOriginalInset: UIEdgeInsets {
        return _scrollViewOriginalInset
    }
    
    /// 父控件
    public var scrollView: UIScrollView? {
        return _scrollView
    }
    
    /// 拉拽的百分比(交给子类重写)
    open var pullingPercent: CGFloat = 0.0 {
        didSet {
            if self.isRefreshing() { return }
            if self.automaticallyChangeAlpha {
                self.alpha = pullingPercent
            }
        }
    }
    
    /// 根据拖拽比例自动切换透明度, 默认是false
    public var automaticallyChangeAlpha: Bool = false {
        didSet {
            if self.isRefreshing() { return }
            if automaticallyChangeAlpha {
                self.alpha = self.pullingPercent
            } else {
                self.alpha = 1.0
            }
        }
    }
    
    /// 内部维护的状态
    private var _state: HPCRefreshState = .idle
    /// 对外公开的刷新状态, 一般交给子类 @objc 内部实现【 默认是普通状态 (通过该方式模拟oc的set and get)】
    open var state: HPCRefreshState {
        get {
            return _state
        }
        set {
            _state = newValue
            /// 加入主队列的目的是等setState: 方法调用完毕后, 设置完文字后再去布局子控件
            DispatchQueue.main.async {
                self.setNeedsLayout()
            }
        }
    }
    
    // MARK: - init
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        /// 准备工作
        self.prepare()
    }
    
    override open func layoutSubviews() {
        self.placeSubViews()
        super.layoutSubviews()
    }
    
    // MARK: - override
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let superView = newSuperview else { return }
        /// 如果不是UIScrollView, 不做任何事情
        if !superView.isKind(of: UIScrollView.self) { return }
        /// 旧的父控件移除监听
        self.removeObservers()
        /// 记录scrollView
        if let scrollView = superView as? UIScrollView {
            /// 新的父控件
            /// 宽度
            self.hpc_w = superView.hpc_w
            /// 位置
            self.hpc_x = 0
            _scrollView = scrollView
            /// 设置永远支持垂直弹簧效果 否则不会出发UIScrollViewDelegate的方法, KVO也会失效
            _scrollView?.alwaysBounceVertical = true
            /// 记录UIScrollView最开始的contentInset
            _scrollViewOriginalInset = scrollView.contentInset
            /// 添加监听
            self.addObservers()
        }
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.state == .willRefresh {
            /// 预防view还未完全显示就调用了beginRefreshing ?????
            /// FIXME: WHY?
            self.state = .refreshing
        }
    }
    
    /// KVO
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        /// 未开启手势交互 或者被隐藏 return
        if !self.isUserInteractionEnabled || self.isHidden { return }
        guard let path = keyPath as NSString? else { return }
        if let chanage = change, path.isEqual(to: HPCRefreshConst.contentSize) {
            self.scrollViewContentSizeDid(change: chanage)
        } else if let change = change, path.isEqual(to: HPCRefreshConst.contentOffset) {
            self.scrollViewContentOffsetDid(change: change)
        } else if let change = change, path.isEqual(to: HPCRefreshConst.panState) {
            self.scrollViewPanStateDid(change: change)
        }
    }
    
    // MARK: - 交给子类们去实现
    
    /// 初始化
    open func prepare() {
        /// 基本属性
        self.autoresizingMask = [.flexibleWidth]
        self.backgroundColor = UIColor.clear
    }
    
    /// 摆放子控件的frame
    open func placeSubViews() {}
    /// 当scrollView的contentOffset发生改变的时候调用
    open func scrollViewContentOffsetDid(change: [NSKeyValueChangeKey: Any]) {}
    /// 当scrollView的contentSize发生改变的时候调用
    open func scrollViewContentSizeDid(change: [NSKeyValueChangeKey: Any]?) {}
    /// 当scrollView的拖拽状态发生改变的时候调用
    open func scrollViewPanStateDid(change: [NSKeyValueChangeKey: Any]) {}
    
    // MARK: - 刷新状态控制
    
    /// 进入刷新状态
    public func beginRefreshing() {
        UIView.animate(withDuration: HPCRefreshConst.fastAnimateDuration) {
            self.alpha = 1.0
        }
        self.pullingPercent = 1.0
        /// 只要正在刷新, 就完全显示
        if self.window != nil {
            self.state = .refreshing
        } else {
            self.state = .willRefresh
            /// 预防从另一个控制器回到这个控制器的情况, 回来要重新刷一下
            self.setNeedsDisplay()
        }
    }
    
    public func beginRefreshingWithCompletionClosure(completionClosure: @escaping () -> Void) {
        self.beginRefreshingCompletionClosure = completionClosure
        self.beginRefreshing()
    }
    
    /// 结束刷新状态
    public func endRefreshing() {
        DispatchQueue.main.async {
            self.state = .idle
        }
    }
    
    public func endRefreshingWithCompletionClosure(completionClosure: @escaping () -> Void) {
        self.endRefreshingCompletionClosure = completionClosure
        self.endRefreshing()
    }
    
    /// 是否正在刷新
    public func isRefreshing() -> Bool {
        return self.state == .refreshing || self.state == .willRefresh
    }
}

// MARK: - public method
extension HPCRefreshComponent {
    
    /// 检测状态
    ///
    /// - Parameters:
    ///   - newState: 新状态
    ///   - oldState: 旧状态
    /// - Returns: 如果两者相同 返回nil, 如果两者不相同, 返回旧的状态
    public func check(newState: HPCRefreshState, oldState: HPCRefreshState) -> HPCRefreshState? {
        return newState == oldState ? nil : oldState
    }
    
    /// 触发回调(交给子类去处理)
    public func executeRefreshingClosure() {
        DispatchQueue.main.async {
            /// 回调方法
            if let refreshClosure = self.refreshingClosure {
                refreshClosure()
            }
            if let beginRefreshClosure = self.beginRefreshingCompletionClosure {
                beginRefreshClosure()
            }
        }
    }
}

// MARK: - observers
extension HPCRefreshComponent {
    
    /// 添加监听
    func addObservers() {
        
        let options: NSKeyValueObservingOptions = [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old]
        self.scrollView?.addObserver(self, forKeyPath: HPCRefreshConst.contentOffset, options: options, context: nil)
        self.scrollView?.addObserver(self, forKeyPath: HPCRefreshConst.contentSize, options: options, context: nil)
        self.pan = self.scrollView?.panGestureRecognizer
        self.pan?.addObserver(self, forKeyPath: HPCRefreshConst.panState, options: options, context: nil)
    }
    
    /// 移除监听
    func removeObservers() {
        
        self.superview?.removeObserver(self, forKeyPath: HPCRefreshConst.contentOffset)
        self.superview?.removeObserver(self, forKeyPath: HPCRefreshConst.contentSize)
        self.pan?.removeObserver(self, forKeyPath: HPCRefreshConst.panState)
        self.pan = nil
    }
}
