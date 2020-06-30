//
//  LanuchAnimationView.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/5/29.
//  Copyright © 2019 颜浪. All rights reserved.
//

import UIKit

import Then
import Lottie
import SnapKit
import RxSwift
import RxCocoa

/// 启动动画
class LanuchAnimationView: UIView {
    
    // 全屏动画 LottieLogo
    private let animViewFull: AnimationView = AnimationView(name: "LottieLogo").then {
        
        $0.contentMode = UIViewContentMode.scaleAspectFill
        $0.isHidden    = true
    }
    
    // 以 image 为底图的动画
    private let launchMask: UIImageView = UIImageView().then {
        
        $0.image    = UIImage(named: "launchAnimationBg")
        $0.isHidden = true
    }
    
    private let animViewImage: AnimationView = AnimationView(name: "launchAnimation").then {
        
        $0.contentMode    = UIViewContentMode.scaleAspectFill
        $0.animationSpeed = 1.2
        
        // Swift版本 这个属性没了
//        $0.cacheEnable = false
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
extension LanuchAnimationView {
    
    private func setupUI() {
        
        animViewFull.frame = self.bounds
        
        addSubview(animViewFull)
        
        launchMask.frame = self.bounds
        animViewImage.frame = self.bounds
        
        addSubview(launchMask)
        launchMask.addSubview(animViewImage)
    }
}

// MARK: - public method
extension LanuchAnimationView {
    
    /// 第一种展示
    ///
    /// - Parameters:
    ///   - target:     目标view
    ///   - completion: 回调
    func showLanuchOne(target: UIView,
                       completion: (() -> Void)? = nil) {
        
        animViewFull.isHidden = false
        launchMask.isHidden   = true
        
        target.addSubview(self)
        
        animViewFull.play(completion: { [weak self] animationFinished in
            
            guard let `self` = self else { return }
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.alpha = 0
                
            }, completion: { [weak self] finished in
                
                guard let `self` = self else { return }
                
                self.removeFromSuperview()
                
                if let c = completion {
                    
                    c()
                }
            })
        })
    }
    
    /// 第二种展示
    ///
    /// - Parameters:
    ///   - target:     目标view
    ///   - completion: 回调
    func showLanuchTwo(target: UIView,
                       completion: (() -> Void)? = nil) {
        
        animViewFull.isHidden = true
        launchMask.isHidden   = false
        
        target.addSubview(self)
        
        animViewImage.play(completion: { [weak self] animationFinished in
            
            guard let `self` = self else { return }
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.launchMask.alpha = 0
                
            }, completion: { [weak self] finished in
                
                guard let `self` = self else { return }
                
                self.removeFromSuperview()
                
                if let c = completion {
                    
                    c()
                }
            })
        })
    }
}
