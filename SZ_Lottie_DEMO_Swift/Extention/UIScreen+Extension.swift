//
//  UIScreen+Extension.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/6/11.
//  Copyright © 2019 颜浪. All rights reserved.
//

import UIKit

public extension UIScreen {
    
    /// 屏幕宽
    var screenWidth: CGFloat {
        
        return UIScreen.main.bounds.size.width
    }
    
    /// 屏幕高
    var screenHeight: CGFloat {
        
        return UIScreen.main.bounds.size.height
    }
    
    /// 导航栏高度
    var navHeight: CGFloat {
        
        return UIDevice.current.isNotchPhone ? 88 : 64
    }
    
    var onePxWidth: CGFloat {
        return 1.0 / UIScreen.main.scale
    }
    
    /// 根据屏幕适配
    ///
    /// - Parameter originalNum: 原始值
    /// - Returns: 适配后的值
    static func layoutUI(originalNum: CGFloat) -> CGFloat {
        
        return UIScreen.main.screenWidth / 375.0 * originalNum
    }
}
