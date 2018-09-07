//
//  Style.extends.swift
//  SwiftStyle
//
//  Created by Patrik Sjöberg on 2018-09-06.
//

import Foundation

extension Style {
    public mutating func style(_ name: String, _ config: Configurator) {
        var style = Style(name, config)
        if !isRoot {
            style._conditions.append(.hasParent(self.name))
        }
        _children.append(style)
    }

    public mutating func inherits(_ name: String) {
        _inheritsNames.append(name)
    }
    
    public mutating func when(_ condition: Condition, _ config: Configurator) {
        var style = Style(name, config)
        style._conditions.append(condition)
        _children.append(style)
    }
    
    mutating func update(with other: Style) {
        backgroundColor = other.backgroundColor ?? backgroundColor
        foregroundColor = other.foregroundColor ?? foregroundColor
        font = other.font ?? font
        fontSize = other.fontSize ?? fontSize
        fontName = other.fontName ?? fontName
        
        cornerRadius = other.cornerRadius ?? cornerRadius
        borderWidth = other.borderWidth ?? borderWidth
        borderColor = other.borderColor ?? borderColor
        
        tintColor = other.tintColor ?? tintColor
        alpha = other.alpha ?? alpha
    }
    
    func updated(with other: Style) -> Style {
        var style = self
        style.update(with: other)
        return style
    }
}
