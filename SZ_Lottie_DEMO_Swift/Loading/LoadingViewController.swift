//
//  LoadingViewController.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/5/28.
//  Copyright © 2019 颜浪. All rights reserved.
//

import UIKit

import Then
import Lottie
import SnapKit
import RxSwift
import RxCocoa

/// loading 和 default 效果展示
class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        loadData()
    }
}

// MARK: - UI
extension LoadingViewController {
    
    /// 设置UI
    private func setupUI() {
        
        view.backgroundColor = UIColor.white
        title = "Loading"
    }
}

// MARK: - private method
extension LoadingViewController {
    
    /// 加载数据
    private func loadData() {
        
        ProgressHUD.showHUDTo(view: view)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(floatLiteral: 5.0)) {
            
            ProgressHUD.hideHUDFrom(view: self.view)
            
            self.showDefaultView(animName: "EmptyStatus", tipsString: "暂无相关数据...")
        }
    }
}
