//
//  Style.swift
//  SwiftStyle
//
//  Created by Patrik Sjöberg on 2018-09-06.
//

import Foundation

public protocol SwiftStyleType {
    typealias Configurator = (inout Style)->()
}

public struct Style: SwiftStyleType {
    public let name: String
    
    public var foregroundColor: UIColor?
    public var backgroundColor: UIColor?
    public var font: UIFont?
    public var fontSize: CGFloat?
    public var fontName: String?
    
    public var cornerRadius: CGFloat?
    public var borderWidth: CGFloat?
    public var borderColor: UIColor?
    
    public var tintColor: UIColor?
    public var alpha: CGFloat?
    
    // Don't forget to add to Style.update(with: )
    
    internal let isRoot: Bool
    
    public init(_ config: Configurator) {
        self.name = "_root"
        self.isRoot = true
        config(&self)
    }
    
    public init(_ name: String, _ config: Configurator) {
        self.name = name
        self.isRoot = false
        config(&self)
    }
    
    var _children: [Style] = []
    var _conditions: [Condition] = []
    var _inheritsNames: [String] = []
}
