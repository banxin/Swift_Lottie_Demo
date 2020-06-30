////
////  TransitionViewController.swift
////  SZ_Lottie_DEMO_Swift
////
////  Created by 山竹 on 2019/5/28.
////  Copyright © 2019 颜浪. All rights reserved.
////
//
//import UIKit
//
//import Then
//import Lottie
//import SnapKit
//import RxSwift
//import RxCocoa
//
///// 转场动画 VC1 不支持了 @山竹
//class TransitionViewController: UIViewController {
//
//    private var giftAnimaView: AnimationView = AnimationView()
//
//    private var giftAnimaView2: AnimationView = AnimationView()
//
//    private let rightBtn: AnimatedSwitch = AnimatedSwitch().then {
//
//        $0.animation = Animation.named("floating_action_button", bundle: Bundle.main)
//        $0.isOn = true
//        $0.frame = CGRect(x: 0, y: 0, width: 40, height: 100)
//        $0.setProgressForState(fromProgress: 0.5, toProgress: 0, forOnState: true)
//        $0.setProgressForState(fromProgress: 0, toProgress: 0.5, forOnState: false)
//    }
//
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//
//        if let url = URL(string: "https://yangtuo.oss-cn-hangzhou.aliyuncs.com/mall2c/happy_gift.json") {
//
//            giftAnimaView = AnimationView(url: url, imageProvider: self, closure: { [weak self] (error) in
//
//                guard let `self` = self else { return }
//
//                if let _ = error {
//
//                    print("网络动画加载失败~~")
//
//                } else {
//
//                    self.playAnim()
//                }
//
//            }, animationCache: self)
//
////            let giftAnimaView: AnimationView = AnimationView(name: "happy_gift")
//
////            let giftAnimaView: AnimationView = AnimationView()
//
////            Animation.loadedFrom(url: url, closure: { [weak self] (anim) in
////
//////                guard let `self` = self else { return }
////
////                giftAnimaView.animation = anim
////
////            }, animationCache: self)
//
//            view.addSubview(giftAnimaView)
//
//            giftAnimaView.snp.makeConstraints { (maker) in
//
//                maker.center.equalToSuperview()
//                maker.size.equalTo(CGSize(width: 400, height: 400))
//            }
//        }
//
//        setupUI()
//    }
//}
//
//extension TransitionViewController {
//
//    /// 获取是异步的，所以需要等待动画获取完成，然后
//    private func playAnim() {
//
//        giftAnimaView.play { (finished) in
//
//            UIView.animate(withDuration: 0.3, animations: {
//
//                self.giftAnimaView.alpha = 0
//
//            }, completion: { (_) in
//
//                self.giftAnimaView.removeFromSuperview()
//            })
//        }
//    }
//}
//
//// MARK: - 等待过程中的展位图片 这个地方不是特别理解， @山竹
//extension TransitionViewController: AnimationImageProvider {
//
//    func imageForAsset(asset: ImageAsset) -> CGImage? {
//
//        print("获取 占位图")
//
//        return nil
//    }
//}
//
//// MARK: - 缓存机制（需要自己实现）
//extension TransitionViewController: AnimationCacheProvider {
//
//    // 获取 缓存
//    func animation(forKey: String) -> Animation? {
//
//        print("获取 缓存")
//
//        return nil
//    }
//
//    // 缓存
//    func setAnimation(_ animation: Animation, forKey: String) {
//
//        print("缓存")
//    }
//
//    // 清除缓存
//    func clearCache() {
//
//        print("清除缓存")
//    }
//}
//
//// MARK: - UI
//extension TransitionViewController {
//
//    private func setupUI() {
//
//        view.backgroundColor = UIColor.white
//
//        title = "Transition Title"
//
//        createNavigationRightButton()
//        createTipsLabel()
//    }
//
//    private func createNavigationRightButton() {
//
//        rightBtn.addTarget(self, action: #selector(touchuedNavRightButton(sender:)), for: .touchUpInside)
//
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
//    }
//
//    private func createTipsLabel() {
//
//        let tips: UILabel = UILabel().then {
//
//            $0.text = "点击右侧按钮，看效果。。。"
//            $0.textColor = UIColor.darkGray
//            $0.textAlignment = .center
//        }
//
//        view.addSubview(tips)
//
//        tips.snp.makeConstraints { (maker) in
//
//            maker.left.right.equalToSuperview()
//            maker.top.equalTo(2000)
//        }
//    }
//}
//
//// MARK: - IBAction
//extension TransitionViewController {
//
//    @objc func touchuedNavRightButton(sender: AnimatedSwitch) {
//
//
//    }
//}
//
////// MARK: - UIViewControllerTransitioningDelegate
////extension TransitionViewController: UIViewControllerTransitioningDelegate {
////
////    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
////
////        let animationController: trans
////    }
////}
