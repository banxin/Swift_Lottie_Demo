//
//  ProgressHUD.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/5/21.
//  Copyright © 2019 颜浪. All rights reserved.
//

import UIKit

import MBProgressHUD
import Lottie
import Then

class HUDCustomView : UIView {
    
    private let animView: AnimationView = AnimationView(name: "spinner_").then {
        
        $0.loopMode = .loop
        $0.backgroundBehavior = .pause
    }
    
    override var intrinsicContentSize: CGSize {
        
        return CGSize(width: 60, height: 60)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
        if let _ = newSuperview {
            
            animView.play()
            
        } else {
            
            animView.stop()
        }
    }
}

// MARK: - UI
extension HUDCustomView {
    
    private func setupUI() {
        
        animView.frame = self.bounds
        addSubview(animView)
    }
}

/// hud
// MARK: - static method
class ProgressHUD: NSObject {
    
    /// show 动画 HUD
    ///
    /// - Parameter view: 父视图
    static func showHUDTo(view: UIView) {
        
        let hud: MBProgressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        
        hud.mode            = .customView
        hud.bezelView.style = .solidColor
        
        hud.customView = HUDCustomView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    }
    
    /// 从父视图上移除 HUD
    ///
    /// - Parameter view: 父视图
    static func hideHUDFrom(view: UIView) {
        
        MBProgressHUD.hide(for: view, animated: true)
    }
}
