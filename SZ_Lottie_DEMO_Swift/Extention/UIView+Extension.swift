//
//  UIView+Extension.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/5/20.
//  Copyright © 2019 颜浪. All rights reserved.
//

import Lottie

extension UIView {
    
    /// frame.origin.x
    public var left: CGFloat {
        
        set {
            
            var frame: CGRect = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        
        get {
            
            return self.frame.origin.x
        }
    }
    
    /// frame.origin.x + frame.size.width
    public var right: CGFloat {
        
        set {
            
            var frame: CGRect = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
        
        get {
            
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    /// frame.origin.y
    public var top: CGFloat {
        
        set {
            
            var frame: CGRect = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        
        get {
            
            return self.frame.origin.y
        }
    }
    
    /// frame.origin.y + frame.size.height
    public var bottom: CGFloat {
        
        set {
            
            var frame: CGRect = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
        
        get {
            
            return self.frame.origin.y + self.frame.size.height
        }
    }
    
    /// center.x
    public var centerX: CGFloat {
        
        set {
            
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
        
        get {
            
            return self.center.x
        }
    }
    
    /// center.y
    public var centerY: CGFloat {
        
        set {
            
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
        
        get {
            
            return self.center.y
        }
    }

}

/// 关联属性 key
private var kUIViewTouchEventKey = "kUIViewTouchEventKey"

/// 点击事件闭包
public typealias UIViewTouchEvent = (AnyObject) -> ()

extension UIView {
    
    private var touchEvent: UIViewTouchEvent? {
        
        set {
            objc_setAssociatedObject(self, &kUIViewTouchEventKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            if let event = objc_getAssociatedObject(self, &kUIViewTouchEventKey) as? UIViewTouchEvent {
                return event
            }
            return nil
        }
    }
    
    /// 添加点击事件
    ///
    /// - Parameter event: 闭包
    func addTouchEvent(event: @escaping UIViewTouchEvent) {
        
        self.touchEvent = event
        // 先判断当前是否有交互事件，如果没有的话。。。所有gesture的交互事件都会被添加进gestureRecognizers中
        if (self.gestureRecognizers == nil) {
            self.isUserInteractionEnabled = true
            // 添加单击事件
            let tapEvent = UITapGestureRecognizer.init(target: self, action: #selector(touchedAciton))
            self.addGestureRecognizer(tapEvent)
        }
    }
    
    /// 点击事件处理
    @objc private func touchedAciton() {
        guard let touchEvent = self.touchEvent else {
            return
        }
        touchEvent(self)
    }
}
