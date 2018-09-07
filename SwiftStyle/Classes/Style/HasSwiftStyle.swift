//
//  HasSwiftStyle.swift
//  SwiftStyle
//
//  Created by Patrik Sjöberg on 2018-09-07.
//

import UIKit

public struct HasSwiftContext {
    public let parent: HasSwiftStyle?
    public let children: [HasSwiftStyle]
}

public protocol HasSwiftStyle {
    var styleName: String? { get set }
    var styleContext: HasSwiftContext { get }
}

