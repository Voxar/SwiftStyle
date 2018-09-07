//
//  Style.apply.swift
//  SwiftStyle
//
//  Created by Patrik Sjöberg on 2018-09-06.
//

import Foundation



extension Style {
    
    public func apply(to object: HasSwiftStyle, recursively: Bool = true) {
        Style.apply(style: self, to: object, recursively: recursively)
    }
    
    public static func apply(style: Style, to object: HasSwiftStyle, recursively: Bool = true) {
        Style.apply(style: style, to: object)
        
        if recursively {
            for object in object.styleContext.children {
                Style.apply(style: style, to: object, recursively: recursively)
            }
        }
    }
    
    struct ResolveContext {
        let object: HasSwiftStyle
        let style: Style
        let heritage: [Style]
        let conditionContext: Condition.Context
        
        init(style: Style, parent: ResolveContext) {
            self.object = parent.object
            self.style = style
            self.heritage = parent.heritage + [parent.style]
            self.conditionContext = parent.conditionContext
        }
        
        init(object: HasSwiftStyle, style: Style) {
            self.object = object
            self.style = style
            self.heritage = []
            self.conditionContext = Condition.Context(object: object)
        }
        
        var children: [Style] {
            return style._children
        }
        var parentStyle: Style? {
            return heritage.last
        }
        var siblingStyles: [Style] {
            return parentStyle?._children ?? []
        }
        var inheritedStyles: [Style] {
            return heritage
                .flatMap { $0._children }
                .filter { style._inheritsNames.contains($0.name) }
        }
    }
    
    static func resolve(_ context: ResolveContext) -> Style? {
        let object = context.object
        guard let styleName = object.styleName else { return nil }
        
        let conditionContext = context.conditionContext
        
        func validate(style: Style) -> Bool {
            if style.isRoot { return true }
            return conditionContext.meetsAll(requirements: style._conditions)
        }
        
        func matchingName(style: Style) -> Bool {
            return style.isRoot || style.name == styleName
        }
        
        func all(_ style: Style) -> [Style] {
            return style._children + style._children.flatMap(all)
        }
        
        let style = context.style
        // find all matching name
        let allStyles = [style] + all(style) // breadth first
        let allMatchingName = allStyles.filter(matchingName)
        let allValidating = allMatchingName.filter(validate)
        
        let allInheriting = allValidating.flatMap { style in
            allStyles.filter( { style._inheritsNames.contains($0.name) }) + [style]
        }
        
        let result = allInheriting.reduce(into: style, {$0.update(with: $1)})
        return result
    }
    
    static func apply(style: Style, to object: HasSwiftStyle) {
        let context = ResolveContext(object: object, style: style)
        guard let style = resolve(context) else {
            return
        }
        
        /// Returns font based on given font + styling
        func resolvedFont(baseFont: UIFont?) -> UIFont? {
            // If there's a font override we use that as base
            let base = style.font ?? baseFont ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
            
            // if there's an override for size we use that
            let fontSize = style.fontSize.flatMap { CGFloat($0) } ?? base.pointSize
            
            // if the font name is not the same as base we return a new font
            if let fontName = style.fontName, fontName != base.fontName {
                return UIFont(name: fontName, size: fontSize) ?? baseFont
            }
            
            // if the font size is changed we return a new font
            if fontSize != base.pointSize {
                return base.withSize(fontSize)
            }
            
            return base
        }
        
        if let view = object as? UIView {
            style.backgroundColor.map { view.backgroundColor = $0 }
            style.cornerRadius.map { view.layer.cornerRadius = $0 }
            style.borderColor.map { view.layer.borderColor = $0.cgColor }
            style.borderWidth.map { view.layer.borderWidth = $0 }
            style.alpha.map { view.alpha = $0 }
            style.tintColor.map { view.tintColor = $0 }
        }
        
        if let view = object as? UILabel {
            style.foregroundColor.map { view.textColor = $0 }
            resolvedFont(baseFont: view.font).map { view.font = $0 }
        }
        
        if let view = object as? UIButton {
            style.foregroundColor.map { view.setTitleColor($0, for: .normal) }
            style.foregroundColor.map { view.tintColor = $0 }
            resolvedFont(baseFont: view.titleLabel?.font).map { view.titleLabel?.font = $0 }
        }
    }
    
}
