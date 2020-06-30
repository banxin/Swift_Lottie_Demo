//
//  UIDevice+Extension.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/5/21.
//  Copyright © 2019 颜浪. All rights reserved.
//

import UIKit

extension UIDevice {
    
    /// 是否是刘海屏
    public var isNotchPhone: Bool {
        
        if #available(iOS 11.0, *) {
            if let keyWindow = UIApplication.shared.delegate?.window,
                let bottonSafeInset = keyWindow?.safeAreaInsets.bottom {
                if bottonSafeInset > 0 {
                    return true
                }
            }
        }
        return false
    }
}
