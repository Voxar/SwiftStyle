import UIKit

//@testable import SwiftStyle
//
//var str = "Hello, playground"
//
//var kps = KeyPathValueStore<UIView>()
//kps[\.backgroundColor] = .blue
//
//kps < .backgroundColor = .blue
//
//style\\.backgroundColor = .blue
//
//print(kps)

protocol RequirementContext {
    associatedtype Requirement: RequirementType
    func meets(requirement: Requirement) -> Bool
}

protocol RequirementType {
}

extension RequirementContext {
    func meetsAll(requirements: [Requirement]) -> Bool {
        return nil == requirements.first(where: {
            self.meets(requirement: $0) == false
        })
    }
}

var NibblerStyleNameKey: UInt8 = 0
extension UIView {
    @IBInspectable public var styleName: String? {
        get { return objc_getAssociatedObject(self, &NibblerStyleNameKey) as? String }
        set { objc_setAssociatedObject(self, &NibblerStyleNameKey, newValue, .OBJC_ASSOCIATION_COPY) }
    }
    
    var stylePath: [String] {
        get { return (superview?.stylePath ?? []) + [styleName].compactMap{$0} }
    }
}


protocol SwiftStyleType {
    typealias Configurator = (inout Style)->()
}


struct Style: SwiftStyleType {
    init(_ name: String, _ config: Configurator) {
        self.name = name
        config(&self)
    }
    
    init(_ name: String, extending: Style, _ config: Configurator) {
        self.name = name
        config(&self)
    }
    
    let name: String
    var foregroundColor: UIColor?
    var backgroundColor: UIColor?
    var fontSize: CGFloat?
    
    enum Condition: Hashable {
        case focused
        case hasParent(String)
    }
    
    
    
    
    private var _whenCases: [Condition: Style] = [:]
    private var _extendingNames: [String] = []
}

extension Style {
    mutating func extends(_ name: String) {
        _extendingNames.append(name)
    }
    
    mutating func when(_ case: Condition, _ config: Configurator) -> Style {
        let style = Style(name, config)
        _whenCases[`case`] = style
        return style
    }
    
    mutating func update(with other: Style) {
        backgroundColor = other.backgroundColor ?? backgroundColor
        foregroundColor = other.foregroundColor ?? foregroundColor
    }
    
    func updated(with other: Style) -> Style {
        var style = self
        style.update(with: other)
        return style
    }
}

extension SwiftStyleType {
    static func style(_ name: String, _ config: (inout Style)->()) -> Style {
        return Style(name, config)
    }
    
    static func style(_ name: String, extending: Style, _ config: (inout Style)->()) -> Style {
        return Style(name, config).updated(with: extending)
    }
}


struct ComHemStyle: SwiftStyleType {
    static let normal = style("normal") { s in
        s.backgroundColor = .blue
        s.foregroundColor = .green
    }
    
    static let larger = style("larger", extending: normal) { s in 
        s.fontSize = s.fontSize.flatMap { $0 * 1.1 } ?? 14
    }
}



let ComHemStyle2 = Style("ComHem") { s in
    s.extends("normal")
    s.backgroundColor = .red
    s.when(.focused) { s in
        s.backgroundColor = .yellow
    }
}
print(ComHemStyle2)
print(ComHemStyle.normal)

extension Style.Condition: RequirementType {
    typealias Requirement = Style.Condition
    struct Context: RequirementContext {
        let view: UIView
        
        func parentMatching(_ matcher: (UIView)->Bool) -> UIView? {
            var view: UIView? = self.view
            while view != nil {
                if let view = view, matcher(view) { return view }
                view = view?.superview
            }
            return nil
        }
        
        func hasParentMatching(_ matcher: (UIView)->Bool) -> Bool {
            return parentMatching(matcher) != nil
        }
        
        func meets(requirement: Requirement) -> Bool {
            switch requirement {
            case .focused:
                return view.isFocused
            case .hasParent(let parentName):
                return hasParentMatching { $0.styleName == parentName }
            }
        }
    }
}
