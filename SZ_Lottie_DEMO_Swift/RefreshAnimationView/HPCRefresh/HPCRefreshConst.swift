//
//  HPCRefreshConst.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/6/14.
//  Copyright © 2019 颜浪. All rights reserved.
//

import UIKit

/// 输出调试信息
public func printf<T>(_ message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    print("[函数名 : \((fileName as NSString).lastPathComponent) \(methodName)]-->[行号 : \(lineNumber)]\n--->> \(message)")
    #endif
}

/// 常量
public struct HPCRefreshConst {

    /// key path
    public static var header = "header"
    public static var footer = "footer"
    
    /// 最后一次下拉刷新存储时间对应的key
    public static let headerLastUpdatedTimeKey = "headerLastUpdatedTimeKey"
    public static let contentOffset = "contentOffset"
    public static let contentInSet = "contentInset"
    public static let contentSize = "contentSize"
    public static let panState = "state"
    
    /// 动画时长
    public static let fastAnimateDuration: TimeInterval = 0.25
    public static let slowAnimateDuration: TimeInterval = 0.4
    
    /// 刷新控件的高度
    public static let headerHeight: CGFloat = 54.0
    public static let footerHeight: CGFloat = 44.0
    public static let lableLeftInset: CGFloat = 25.0
    
    public static let autoFooterIdleText = "点击或上拉加载更多"
    public static let autoFooterRefreshingText = "正在加载更多的数据..."
    public static let autoFooterNoMoreDataText = "已经全部加载完毕"
}
