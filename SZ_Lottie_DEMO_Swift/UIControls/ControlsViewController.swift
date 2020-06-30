//
//  ControlsViewController.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/5/21.
//  Copyright © 2019 颜浪. All rights reserved.
//

import UIKit

import Then
import Lottie

class ControlsViewController: UIViewController {
    
    private var isShowGift: Bool = false

    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
    }
}

extension ControlsViewController {
    
    private func setupUI() {
        
        view.backgroundColor = UIColor.white
        
        title = "Controls Demo"
        
        setupNavRightBtn()
        
        setupToggle()
    }
    
    private func setupNavRightBtn() {
        
        let animView: AnimationView = AnimationView(name: "restless_gift")
        
        animView.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        animView.loopMode = .loop
        animView.play()
        
        animView.addTouchEvent { [weak self] (_) in
            
            guard let `self` = self else { return }
            
            if !self.isShowGift { self.showGift() }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: animView)
    }
    
    private func setupToggle() {
        
        // 开关动画，有 开动画 和 关动画
        let toggle1: AnimatedSwitch = AnimatedSwitch()
        
        // 有个命名空间的问题，跨包使用时需要注意
        toggle1.animation = Animation.named("switch_test")
        // 开动画 的范围为 动画过程 的 0.5 到 1
        toggle1.setProgressForState(fromProgress: 0.5, toProgress: 1, forOnState: true)
        // 关动画 的范围为 动画过程 的 0 到 0.5
        toggle1.setProgressForState(fromProgress: 0, toProgress: 0.5, forOnState: false)
        
        toggle1.addTarget(self, action: #selector(switchToggled(sender:)), for: .touchUpInside)
        
        view.addSubview(toggle1)
        
        // 开关动画，有 开动画 和 关动画
        let toggle2: AnimatedSwitch = AnimatedSwitch()
        
        toggle2.animation = Animation.named("lemon_on_off")
        // 开动画 的范围为 动画过程 的 1 到 0.5
        toggle2.setProgressForState(fromProgress: 1, toProgress: 0.5, forOnState: true)
        // 关动画 的范围为 动画过程 的 0.5 到 1
        toggle2.setProgressForState(fromProgress: 0.5, toProgress: 1, forOnState: false)
        
        /// 设置哪个动画层对于给定状态应该是可见的。这个是从json文件中指定的
        toggle2.setLayer(named: "Button", forState: .normal)
        toggle2.setLayer(named: "Disabled", forState: .disabled)
        
        toggle2.addTarget(self, action: #selector(switchToggled(sender:)), for: .touchUpInside)
        
        view.addSubview(toggle2)
        
        // 动画的进程 为 0 ~ 1，0，为关闭状态，1，为开启状态
        let toggle3: AnimatedSwitch = AnimatedSwitch()
        
        toggle3.animation = Animation.named("like")
        /*
         与OC版本不同，如果希望初始化 是指定的状态，而不是立即播放动画，则需要调用这个方法
         */
        // 开动画 的范围为 动画过程 的 1 到 0
        toggle3.setProgressForState(fromProgress: 0, toProgress: 1, forOnState: true)
        // 关动画 的范围为 动画过程 的 0 到 1
        toggle3.setProgressForState(fromProgress: 1, toProgress: 0, forOnState: false)
        
        toggle3.addTarget(self, action: #selector(switchToggled(sender:)), for: .touchUpInside)
        
        view.addSubview(toggle3)
        
        // 当开关关闭时，显示禁用层(动画JSON中指定了 关闭和开启的 图层)
        let toggle4: AnimatedSwitch = AnimatedSwitch()
        
        toggle4.animation = Animation.named("Switch_States")
        // 开动画 的范围为 动画过程 的 1 到 0
        toggle4.setProgressForState(fromProgress: 1, toProgress: 0, forOnState: true)
        // 关动画 的范围为 动画过程 的 0 到 1
        toggle4.setProgressForState(fromProgress: 0, toProgress: 1, forOnState: false)
        
        /**
         * Map a specific animation layer to a control state.
         * 将特定动画层映射到控件状态。
         * When the state is set all layers will be hidden except the specified layer.
         * 当状态被设置时，除了指定的层之外，所有的层都将被隐藏。
         **/
        // Specify the layer names for different states
        // 为不同的状态指定层名称( 慎用 !!! )
//        toggle4.setLayer(named: "Button", forState: .normal)
//        toggle4.setLayer(named: "Disabled", forState: .disabled)
//
//        // 可用
//        toggle4.isEnabled = true
//        // 不可用
//        toggle4.isEnabled = false
        
        toggle4.addTarget(self, action: #selector(switchToggled(sender:)), for: .touchUpInside)
        
        view.addSubview(toggle4)
        
        toggle1.snp.makeConstraints { (maker) in
            
            maker.centerX.equalToSuperview()
            maker.top.equalTo(120)
            maker.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        toggle2.snp.makeConstraints { (maker) in
            
            maker.centerX.equalToSuperview()
            maker.top.equalTo(toggle1.snp.bottom).offset(50)
            maker.size.equalTo(toggle1)
        }
        
        toggle3.snp.makeConstraints { (maker) in
            
            maker.centerX.equalToSuperview()
            maker.top.equalTo(toggle2.snp.bottom).offset(50)
            maker.size.equalTo(toggle1)
        }
        
        toggle4.snp.makeConstraints { (maker) in
            
            maker.centerX.equalToSuperview()
            maker.top.equalTo(toggle3.snp.bottom).offset(50)
            maker.size.equalTo(toggle1)
        }
    }
}

// MARK: - IBAction
extension ControlsViewController {
    
    @objc func switchToggled(sender: AnimatedSwitch) {
        
        print("The selected state is \(sender.isOn ? "YES" : "NO")")
        
        /*
         OC 可以有个完成回调，不过在Swift中 animationView 变为了 私有属性，这个回调拿不到了，只能根据状态来判断
         */
        // 动画完成之后，做一些事情
        //    animatedSwitch.animationView.completionBlock = ^(BOOL animationFinished) {
        //
        //        NSLog(@"开关动画的状态为 %@", (animatedSwitch.on ? @"开" : @"关"));
        //    };
    }
}

// MARK: - private method
extension ControlsViewController {
    
    private func showGift() {
        
        isShowGift = true
        
        let giftAnimaView: AnimationView = AnimationView(name: "happy_gift")
        
        view.addSubview(giftAnimaView)
        
        giftAnimaView.snp.makeConstraints { (maker) in
            
            maker.center.equalToSuperview()
            maker.size.equalTo(CGSize(width: 400, height: 400))
        }
        
        giftAnimaView.play { (finished) in
            
            UIView.animate(withDuration: 0.3, animations: {
                
                giftAnimaView.alpha = 0
                
            }, completion: { (_) in
                
                giftAnimaView.removeFromSuperview()
                
                self.isShowGift = false
            })
        }
    }
}
