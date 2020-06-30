//
//  UIScrollView+HPCRefesh.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/6/14.
//  Copyright © 2019 颜浪. All rights reserved.
//

import UIKit

// MARK: - HPCRefesh
public extension UIScrollView {
    
    /// refresh header
    @objc dynamic var hpc_header: HPCRefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &HPCRefreshConst.header) as? HPCRefreshHeader
        }
        set {
            if let newHeader = newValue {
                if let oldHeader = hpc_header {
                    /// 存在旧值，先移除
                    oldHeader.removeFromSuperview()
                }
                self.insertSubview(newHeader, at: 0)
                objc_setAssociatedObject(self, &HPCRefreshConst.header, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            }
        }
    }
    
    /// refresh footer
    @objc dynamic var hpc_footer: HPCRefreshFooter? {
        get {
            return objc_getAssociatedObject(self, &HPCRefreshConst.footer) as? HPCRefreshFooter
        }
        set {
            if let newFooter = newValue {
                if let oldFooter = hpc_footer {
                    /// 存在旧值，先移除
                    oldFooter.removeFromSuperview()
                }
                self.insertSubview(newFooter, at: 0)
                objc_setAssociatedObject(self, &HPCRefreshConst.footer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            }
        }
    }
}

// MARK: - HPCRefresh UIScrollView 扩展
public extension UIScrollView {
    
    var hpc_inset: UIEdgeInsets {
        
        if #available(iOS 11.0, *) {
            return adjustedContentInset
        }
        
        return contentInset
    }
    
    var hpc_insetT: CGFloat {
        
        set {
            var tempInset = self.contentInset
            tempInset.top = newValue
            if #available(iOS 11.0, *) {
                tempInset.top -= (self.adjustedContentInset.top - self.contentInset.top)
            }
            self.contentInset = tempInset
        }
        get {
            return self.hpc_inset.top
        }
    }
    
    var hpc_insetB: CGFloat {
        
        set {
            var tempInset = self.contentInset
            tempInset.bottom = newValue
            if #available(iOS 11.0, *) {
                tempInset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom)
            }
            self.contentInset = tempInset
        }
        get {
            return self.hpc_inset.bottom
        }
    }
    
    var hpc_insetL: CGFloat {
        
        set {
            var tempInset = self.contentInset
            tempInset.left = newValue
            if #available(iOS 11.0, *) {
                tempInset.left -= (self.adjustedContentInset.left - self.contentInset.left)
            }
            self.contentInset = tempInset
        }
        get {
            return self.hpc_inset.left
        }
    }
    
    var hpc_insetR: CGFloat {
        
        set {
            var tempInset = self.contentInset
            tempInset.right = newValue
            if #available(iOS 11.0, *) {
                tempInset.right -= (self.adjustedContentInset.right - self.contentInset.right)
            }
            self.contentInset = tempInset
        }
        get {
            return self.hpc_inset.right
        }
    }
    
    var hpc_offsetX: CGFloat {
        
        set {
            var tempOffset = self.contentOffset
            tempOffset.x = newValue
            self.contentOffset = tempOffset
        }
        get {
            return self.contentOffset.x
        }
    }
    
    var hpc_offsetY: CGFloat {
        
        set {
            var tempOffset = self.contentOffset
            tempOffset.y = newValue
            self.contentOffset = tempOffset
        }
        get {
            return self.contentOffset.y
        }
    }
    
    var hpc_contentW: CGFloat {
        
        set {
            var tempSize = self.contentSize
            tempSize.width = newValue
            self.contentSize = tempSize
        }
        get {
            return self.contentSize.width
        }
    }
    
    var hpc_contentH: CGFloat {
        
        set {
            var tempSize = self.contentSize
            tempSize.height = newValue
            self.contentSize = tempSize
        }
        get {
            return self.contentSize.height
        }
    }
}

// MARK: - HPCRefresh UIView 扩展
public extension UIView {
    
    var hpc_x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    var hpc_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var hpc_w: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    var hpc_h: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    var hpc_size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.frame.size = newValue
        }
    }
    
    var hpc_origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame.origin = newValue
        }
    }
}
