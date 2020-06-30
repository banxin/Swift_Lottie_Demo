//
//  ServeAnimationViewController.swift
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

/// 动画文件来自网络 DEMO
class ServeAnimationViewController: UIViewController {
    
    private var giftAnimaView: AnimationView = AnimationView()
    
    private var giftAnimaView2: AnimationView = AnimationView()
    
    private let rightBtn: AnimatedSwitch = AnimatedSwitch().then {
        
        $0.animation = Animation.named("floating_action_button", bundle: Bundle.main)
        $0.isOn = true
        $0.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        $0.setProgressForState(fromProgress: 0.5, toProgress: 0, forOnState: true)
        $0.setProgressForState(fromProgress: 0, toProgress: 0.5, forOnState: false)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
    }
}

// MARK: - UI
extension ServeAnimationViewController {
    
    private func setupUI() {
        
        view.backgroundColor = UIColor.white
        
        title = "ServeAnimation Title"
        
        setupNavRightBtn()
        setupTips()
        createAnimationView()
        createGiftAnimation()
    }
    
    private func setupNavRightBtn() {
        
        let animView: AnimationView = AnimationView(name: "restless_gift")
        
        animView.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        animView.loopMode = .loop
        animView.play()
        
        animView.addTouchEvent { [weak self] (_) in
            
            guard let `self` = self else { return }
            
            self.showAnimation()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: animView)
    }
    
    private func setupTips() {
        
        let tips: UILabel = UILabel().then { (lbl) in
            
            lbl.text = "动画资源来自服务器~~~"
            lbl.textColor = UIColor.blue
            lbl.font = UIFont.systemFont(ofSize: 16)
            lbl.textAlignment = .center
        }
        
        view.addSubview(tips)
        
        tips.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(200)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func createAnimationView() {
        
        if let url = URL(string: "https://yangtuo.oss-cn-hangzhou.aliyuncs.com/mall2c/happy_gift.json") {
            
            giftAnimaView = AnimationView(url: url, imageProvider: self, closure: { [weak self] (error) in
                
                guard let `self` = self else { return }
                
                if let _ = error {
                    
                    print("网络动画加载失败~~")
                    
                } else {
                    
                    self.playAnim()
                }
                
                }, animationCache: self)
            
            view.addSubview(giftAnimaView)
            
            giftAnimaView.snp.makeConstraints { (maker) in
                
                maker.center.equalToSuperview()
                maker.size.equalTo(CGSize(width: 400, height: 400))
            }
        }
    }
    
    private func createGiftAnimation() {
        
        giftAnimaView2.isHidden = true
        
        view.addSubview(giftAnimaView2)
        
        giftAnimaView2.snp.makeConstraints { (maker) in
            
            maker.center.equalToSuperview()
            maker.size.equalTo(CGSize(width: 400, height: 400))
        }
    }
}

// MARK: - IBAction
extension ServeAnimationViewController {
    
    @objc func touchuedNavRightButton(sender: AnimatedSwitch) {
        
        showAnimation()
    }
}

// MARK: - private method
extension ServeAnimationViewController {
    
    /// 获取是异步的，所以需要等待动画获取完成，然后
    private func playAnim() {
        
        giftAnimaView.play { (finished) in
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.giftAnimaView.alpha = 0
                
            }, completion: { (_) in
                
                self.giftAnimaView.removeFromSuperview()
            })
        }
    }

    private func showAnimation() {
        
        if let url = URL(string: "https://yangtuo.oss-cn-hangzhou.aliyuncs.com/mall2c/happy_gift.json") {
            
            giftAnimaView2.isHidden = false
            //            giftAnimaView2.loopMode = .loop
            
            Animation.loadedFrom(url: url, closure: { [weak self] (anim) in
                
                guard let `self` = self else { return }
                
                self.giftAnimaView2.isHidden = false
                
                self.giftAnimaView2.animation = anim
                //                self.giftAnimaView2.play()
                self.giftAnimaView2.play(completion: { [weak self] (isFinish) in
                    
                    guard let `self` = self else { return }
                    
                    if isFinish {
                        
                        self.giftAnimaView2.isHidden = true
                    }
                })
                
                }, animationCache: self)
        }
    }
}

// MARK: - 图片提供协议，复杂动画需要用到指定图片，由这个协议返回，可以是本地图片，也可以从网络获取
extension ServeAnimationViewController: AnimationImageProvider {
    
    /**
         图像提供程序是一种用于向“AnimationView”提供图像的协议。
       
         某些动画需要引用图像。 图像提供程序加载和
         将这些图像提供给`AnimationView`。 洛蒂包括几个
         预先构建的映像提供程序，它们从Bundle或FilePath提供映像。
       
         此外，可以使自定义图像提供程序从URL加载图像，
         或缓存图像。
       */
    func imageForAsset(asset: ImageAsset) -> CGImage? {
        
        print("获取 动画文件中需要的图片资源")
        
        return nil
    }
}

// MARK: - 缓存机制（需要自己实现 ！！！ ）
extension ServeAnimationViewController: AnimationCacheProvider {
    
    // 获取 缓存
    func animation(forKey: String) -> Animation? {
        
        print("获取 缓存")
        
        return nil
    }
    
    // 缓存
    func setAnimation(_ animation: Animation, forKey: String) {
        
        print("缓存")
    }
    
    // 清除缓存
    func clearCache() {
        
        print("清除缓存")
    }
}
