//
//  SZTabbarViewController.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/11/28.
//  Copyright © 2019 颜浪. All rights reserved.
//

import UIKit
import Lottie
import Then

class SZTabbarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

extension SZTabbarViewController {
    func setupUI() {
        delegate = self
        
        
    }
    
    func setupRoots() {
//        let vc1 = UINavigationController(rootViewController: MainListViewController())
//        let vc2 = UINavigationController(rootViewController: TestViewController())
        
    }
}

extension SZTabbarViewController: UITabBarControllerDelegate {
    
}
