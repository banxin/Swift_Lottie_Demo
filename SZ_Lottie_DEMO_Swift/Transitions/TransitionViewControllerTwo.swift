//
//  TransitionViewControllerTwo.swift
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

class TransitionViewControllerTwo: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        let animationView = AnimationView(name: "someJSONFileName")
        
        animationView.play()
        animationView.pause()
        animationView.stop()
        
        // 填充模式
        animationView.contentMode = .scaleToFill
        animationView.frame = view.bounds
        
        view.addSubview(animationView)
        
        animationView.play()
        /**
                             将进度（0-1）中的动画播放到进度（0-1）。
                           
                               - 参数fromProgress：动画的开始进度。 如果是'nil`，动画将从当前进度开始。
                               - 参数toProgress：动画的结束进度。
                               - 参数toProgress：动画的循环行为。 如果是`nil`，将使用视图的`loopMode`属性。
                               - 参数完成：动画停止时要调用的可选完成闭包。
                           */
        
        /**
         播放动画，进度（0 ~ 1）.
         
         - Parameter fromProgress: 动画的开始进度。 如果是'nil`，动画将从当前进度开始。
         - Parameter toProgress: 动画的结束进度。
         - Parameter toProgress: 动画的循环行为。 如果是`nil`，将使用视图的`loopMode`属性。默认是 .playOnce
         - Parameter completion: 动画停止时要调用的可选完成闭包。
         */
//        public func play(fromProgress: AnimationProgressTime? = nil,
//                         toProgress: AnimationProgressTime,
//                         loopMode: LottieLoopMode? = nil,
//                         completion: LottieCompletionBlock? = nil)
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: .playOnce) { (isFinished) in
            // 播放到指定进度
        }
        
        // 设置当前进度
        animationView.currentProgress = 0.5
        
        /**
                             以动画的帧速率从开始帧到结束帧播放动画。
                           
                               - 参数fromProgress：动画的开始进度。 如果是'nil`，动画将从当前进度开始。
                               - 参数toProgress：动画的结束进度。
                               - 参数toProgress：动画的循环行为。 如果是`nil`，将使用视图的`loopMode`属性。
                               - 参数完成：动画停止时要调用的可选完成闭包。
                           */
        
        /**
         使用帧的方式播放动画
         
         - Parameter fromProgress: 动画的开始进度。 如果是'nil`，动画将从当前进度开始。
         - Parameter toProgress: 动画的结束进度
         - Parameter toProgress: 动画的循环行为。 如果是`nil`，将使用视图的`loopMode`属性。
         - Parameter completion: 动画停止时要调用的可选完成闭包。
         */
//        public func play(fromFrame: AnimationFrameTime? = nil,
//                         toFrame: AnimationFrameTime,
//                         loopMode: LottieLoopMode? = nil,
//                         completion: LottieCompletionBlock? = nil)
        animationView.play(fromFrame: 50, toFrame: 80, loopMode: .loop) { (isFinished) in
            // 播放完成后的回调闭包
        }
        // 设置当前帧
        animationView.currentFrame = 65
        
        
        // 循环模式
        animationView.loopMode = .playOnce
        
        /**
         到后台时AnimationView的行为。
       
         默认为“暂停”，在到后台时暂停动画。 回调会以“false”调用完成。
       */
        
//        /// 到后台时AnimationView的行为
//        public enum LottieBackgroundBehavior {
//            /// 停止动画并将其重置为当前播放时间的开头。 调用完成回调。
//            case stop
//            /// 暂停动画，回调会以“false”调用完成。
//            case pause
//            /// 暂停动画并在应到前台时重新启动它，在动画完成时调用回调
//            case pauseAndRestore
//        }
        
        // 到后台的行为模式
        animationView.backgroundBehavior = .pause
        
        // 根据动画指定 对应的 关键路径 例如：“Background 2.Shape 1.Fill 1.Color” @山竹，这个玩意我也还没搞懂
        /// *** Keypath Setting
        
        let redValueProvider = ColorValueProvider(Color(r: 1, g: 0.2, b: 0.3, a: 1))
        animationView.setValueProvider(redValueProvider, keypath: AnimationKeypath(keypath: "BG-On.Group 1.Fill 1.Color"))
        
        let otherValueProvider = ColorValueProvider(Color(r: 0.3, g: 0.2, b: 0.3, a: 1))
        animationView.setValueProvider(otherValueProvider, keypath: AnimationKeypath(keypath: "BG-Off.Group 1.Fill 1.Color"))
    }

}
