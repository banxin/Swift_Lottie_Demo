//
//  HPCRefreshFooter.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/5/28.
//  Copyright © 2019 颜浪. All rights reserved.
//

import Lottie
import Then

/// HPC 底部刷新
open class HPCRefreshLottieFooter: HPCRefreshAutoFooter {

    /// 动画
    private var animView: AnimationView = AnimationView(name: "hipac_pull_new").then {
        
        $0.contentMode        = UIViewContentMode.scaleAspectFill
        $0.loopMode           = .loop
        $0.backgroundBehavior = .pauseAndRestore
    }
    
    /// 底部提示
    private var tips: UILabel = UILabel().then {
        
        $0.font          = UIFont(name: "PingFangSC-Regular", size: 10)
        $0.textColor     = UIColor.lightGray
        $0.textAlignment = .center
        $0.text          = HPCRefreshConst.autoFooterIdleText
    }
    
    /// 完成提示
    private var finishedTips: UILabel = UILabel().then {
        
        $0.font          = UIFont(name: "PingFangSC-Regular", size: 12)
        $0.textColor     = UIColor.lightGray
        $0.textAlignment = .center
        $0.text          = HPCRefreshConst.autoFooterNoMoreDataText
    }
    
    // 在这里做一些初始化配置（比如添加子控件）
    open override func prepare() {
        
        super.prepare()
        
        setupUI()
    }
    
    // 设置子控件的位置和尺寸
    open override func placeSubViews() {
        
        super.placeSubViews()
        
        animView.bounds = CGRect(x: 0, y: 0, width: 24, height: 24)
        animView.center = CGPoint(x: hpc_w * 0.5, y: hpc_h * 0.5 - 9)
        
        finishedTips.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 10)
        finishedTips.center = CGPoint(x: hpc_w * 0.5, y: hpc_h * 0.5)
        
        tips.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 10)
        tips.center = CGPoint(x: animView.center.x, y: animView.center.y + 21)
    }
    
    // 监听控件的刷新状态
    open override var state: HPCRefreshState {
        
        didSet {
            
            // 状态检查 (如果新状态等于老状态，忽略)
            if oldValue == state { return }
            
            super.state = state
            
            animView.isHidden     = false
            tips.isHidden         = false
            finishedTips.isHidden = true
            
            // 根据状态做事情
            if state == .refreshing {
                
                tips.text = HPCRefreshConst.autoFooterRefreshingText
                playAnima()
                
            } else if state == .idle {
                
                tips.text = HPCRefreshConst.autoFooterIdleText
                animView.stop()
                
            } else if state == .noMoreData {
                
                finishedTips.isHidden = false
                animView.isHidden     = true
                tips.isHidden         = true
                animView.stop()
            }
        }
    }
    
    // 监听拖拽比例（控件被拖出来的比例）
    open override var pullingPercent: CGFloat {
        
        didSet {
            
            super.pullingPercent = pullingPercent
            
            if self.state != .idle { return }

            self.animView.currentProgress = pullingPercent
        }
    }
}

// MARK: - UI
extension HPCRefreshLottieFooter {
    
    /// 设置UI
    private func setupUI() {
        
        // 自定义控件高度
        hpc_h = 62
        
        addSubview(animView)
        addSubview(finishedTips)
        addSubview(tips)
    }
}

// MARK: - private mehthod
extension HPCRefreshLottieFooter {
    
    private func playAnima() {
        
        animView.animationSpeed = 1.5
        animView.play()
    }
}
