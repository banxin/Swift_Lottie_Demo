//
//  HPCRefreshHeader.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/5/27.
//  Copyright © 2019 颜浪. All rights reserved.
//

import Lottie
import Then

/// HPC 头部刷新
open class HPCRefreshLottieHeader: HPCRefreshHeader {
    
    private var animView: AnimationView = AnimationView(name: "hipac_pull_new").then {
        
        $0.contentMode        = UIViewContentMode.scaleAspectFill
        $0.backgroundBehavior = .pauseAndRestore
    }
    
//    // 左右蒙层
//
//    private var leftView: UIView = UIView().then {
//
//        $0.backgroundColor = UIColor.clear
//    }
//
//    private var rightView: UIView = UIView().then {
//
//        $0.backgroundColor = UIColor.clear
//    }
    
    // 在这里做一些初始化配置（比如添加子控件）
    open override func prepare() {
        
        super.prepare()
        
        setupUI()
    }
    
    // 设置子控件的位置和尺寸
    open override func placeSubViews() {
        
        super.placeSubViews()
        
        animView.bounds = CGRect(x: 0, y: 0, width: 150, height: 66)
        animView.center = CGPoint(x: hpc_w * 0.5, y: hpc_h * 0.5)
//        leftView.frame = CGRect(x: animView.left - 20, y: 0, width: 40, height: 75)
//        rightView.frame = CGRect(x: animView.right - 20, y: 0, width: 40, height: 75)
    }
    
    // 监听控件的刷新状态
    open override var state: HPCRefreshState {
        
        didSet {
            
            // 状态检查 (如果新状态等于老状态，忽略)
            if oldValue == state { return }
            
            super.state = state
            
            switch state {
            case .idle:
                self.animView.stop()
                break
            case .pulling:
                self.showLoopAnim()
                break
            case .refreshing:
                self.showLoopAnim()
                break
            default:
                break
            }
        }
    }
    
    // 监听拖拽比例（控件被拖出来的比例）
    open override var pullingPercent: CGFloat {
        
        didSet {
            
            super.pullingPercent = pullingPercent
            
            if self.state != .idle { return }
            
            // 单次播放只需要走到 43 帧，剩下的所有帧 走 循环
            animView.currentFrame = pullingPercent * 43
        }
    }
}

// MARK: - UI
extension HPCRefreshLottieHeader {
    
    /// 设置UI
    private func setupUI() {
        
        // 自定义控件高度
        hpc_h = 66
        
        addSubview(animView)
        
        // 背景色不统一，所以该方案往后靠
//        addSubview(leftView)
//        addSubview(rightView)
//        leftView.layer.addSublayer(gradientBackgroundLayer(bounds: CGRect(x: 0, y: 0, width: 40, height: 75),
//                                                           colors: [UIColor.colorWithHex(hexString: "f8f8f8").cgColor,
//                                                                    UIColor.colorWithHex(hexString: "f8f8f8").withAlphaComponent(0.1).cgColor],
//                                                           startPoint: CGPoint(x: 0, y: 0.5),
//                                                           endPoint: CGPoint(x: 1, y: 0.5),
//                                                           locations: [NSNumber(value: 0.8),
//                                                                       NSNumber(value: 1)]))
//        rightView.layer.addSublayer(gradientBackgroundLayer(bounds: CGRect(x: 0, y: 0, width: 40, height: 75),
//                                                            colors: [UIColor.colorWithHex(hexString: "f8f8f8").cgColor,
//                                                                     UIColor.colorWithHex(hexString: "f8f8f8").withAlphaComponent(0.1).cgColor],
//                                                            startPoint: CGPoint(x: 1, y: 0.5),
//                                                            endPoint: CGPoint(x: 0, y: 0.5),
//                                                            locations: [NSNumber(value: 0.8),
//                                                                        NSNumber(value: 1)]))
    }
    
    /// 播放指定的循环动画
    private func showLoopAnim() {
        
        animView.currentFrame = 43
        animView.play(fromFrame: 43, toFrame: 89, loopMode: .loop, completion: nil)
    }
    
    // 获取渐变
    private func gradientBackgroundLayer(bounds: CGRect,
                                         colors: [CGColor],
                                         startPoint: CGPoint,
                                         endPoint: CGPoint,
                                         locations: [NSNumber],
                                         cornerRadius: CGFloat = 0) -> CAGradientLayer {
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        gradientLayer.frame      = bounds
        gradientLayer.colors     = colors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint   = endPoint
        gradientLayer.locations  = locations
        
        return gradientLayer
    }
}


extension UIColor {
    
    static func colorWithHex(hexString hex: String, alpha: CGFloat = 1) -> UIColor {
        // 去除空格等
        var cString: String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        // 去除#
        if cString.hasPrefix("#") {
            cString = (cString as NSString).substring(from: 1)
        }
        // 必须为6位
        if cString.count != 6 {
            return UIColor.gray
        }
        // 红色的色值
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        // 字符串转换
        var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}
