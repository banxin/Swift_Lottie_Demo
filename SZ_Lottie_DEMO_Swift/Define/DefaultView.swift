//
//  DefaultView.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/5/21.
//  Copyright © 2019 颜浪. All rights reserved.
//

import UIKit

import Then
import Lottie
import SnapKit

/// 默认页面
class DefaultView: UIView {
    
    /// 动画
    private let animView: AnimationView = AnimationView(name: "EmptyStatus").then {
        
//        $0.frame = CGRect(x: 0,
//                          y: 0,
//                          width: UIScreen.main.bounds.size.width,
//                          height: UIScreen.main.bounds.size.height * 0.4)
        // 循环播放
        $0.loopMode = .loop
        // 默认值到后台暂停，到前台继续播放完，然后暂停
        // pauseAndRestore 后台到前台，接着没播放完的继续播放，如果是已经暂停了，则从开始开始播放，需要循环播放的动画，使用该属性
        $0.backgroundBehavior = .pause
    }
    
    private let lblTips: UILabel = UILabel().then {
        
        $0.textAlignment = .center
        $0.textColor = UIColor.gray
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension DefaultView {
    
    private func setupUI() {
        
        backgroundColor = UIColor.white
        
        addSubview(animView)
        addSubview(lblTips)
        
        animView.snp.makeConstraints { (maker) in
            
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
        
        lblTips.snp.makeConstraints { (maker) in
            
            maker.left.right.equalToSuperview()
            maker.top.equalTo(animView.snp.bottom)
        }
    }
}

// MARK: - public method
extension DefaultView {
    
    /// 设置页面数据
    ///
    /// - Parameters:
    ///   - animName:   动画 JSON 名
    ///   - tipsString: 提示语
    func setupAnimationName(animName: String?, tipsString: String) {
        
        if let name = animName {
            
            animView.animation = Animation.named(name)
        }
        
        animView.play()
        lblTips.text = tipsString
    }
}


// MARK: - --------------------- 我是分割线 ---------------------

// MARK: - 默认页面
extension UIViewController {
    
    /// 设置页面数据
    ///
    /// - Parameters:
    ///   - animName:   动画 JSON 名
    ///   - tipsString: 提示语
    func showDefaultView(animName: String?, tipsString: String) {
        
        var defaultView: DefaultView? = getDefaultView()
        
        if defaultView == nil {
            
            let newView = DefaultView(frame: self.view.bounds)
            
            view.addSubview(newView)
            
            defaultView = newView
        }
        
        if let sub = defaultView {
            
            sub.setupAnimationName(animName: animName, tipsString: tipsString)
        }
    }
    
    /// 隐藏 默认view
    func hideDefaultView() {
        
        if let view = getDefaultView() {
            
            view.removeFromSuperview()
        }
    }
}

// MARK: - private method
extension UIViewController {
    
    /// 从 self.view 获取 defaultView
    ///
    /// - Returns: 如果存在，则返回defaultView，不存在则返回nil
    private func getDefaultView() -> DefaultView? {
        
        let subviewsEnum = view.subviews.reversed()
        
        for subView in subviewsEnum {
            
            if subView.isKind(of: DefaultView.self),
                let sub = subView as? DefaultView {
                
                return sub
            }
        }
        
        return nil
    }
}
