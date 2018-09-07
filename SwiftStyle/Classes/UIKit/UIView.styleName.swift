//
//  UIView.styleName.swift
//  SwiftStyle
//
//  Created by Patrik Sjöberg on 2018-09-06.
//

import UIKit

var NibblerStyleNameKey: UInt8 = 0
extension UIView: HasSwiftStyle {
    @IBInspectable public var styleName: String? {
        get { return objc_getAssociatedObject(self, &NibblerStyleNameKey) as? String }
        set { objc_setAssociatedObject(self, &NibblerStyleNameKey, newValue, .OBJC_ASSOCIATION_COPY) }
    }
    
    public var styleContext: HasSwiftContext {
        return HasSwiftContext(parent: superview, children: subviews)
    }
}
