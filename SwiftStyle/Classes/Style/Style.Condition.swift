//
//  Style.Condition.swift
//  SwiftStyle
//
//  Created by Patrik Sjöberg on 2018-09-06.
//

import Foundation

extension Style {
    public enum Condition: Hashable {
        @available(iOS 9.0, tvOS 9.0, *)
        case focused
        case highlighted
        case hasStyleName(String)
        case hasParent(String)
    }
}

extension Style.Condition: RequirementType {
    typealias Requirement = Style.Condition
    struct Context: RequirementContext {
        let object: HasSwiftStyle
        
        var objectIsFocused: Bool {
            if #available(iOS 11.0, *) {
                return (object as? UIFocusItem)?.isFocused ?? false
            } else {
                return false
            }
        }
        
        var objectIsHighlighted: Bool {
            switch object {
            case let object as UIControl:
                return object.isHighlighted
            case let object as UICollectionViewCell:
                return object.isHighlighted
            case let object as UITableViewCell:
                return object.isHighlighted
            default:
                return false
            }
        }
        
        func parentMatching(_ matcher: (HasSwiftStyle)->Bool) -> HasSwiftStyle? {
            var object: HasSwiftStyle? = self.object.styleContext.parent
            while object != nil {
                if let object = object, matcher(object) {
                    return object
                }
                object = object?.styleContext.parent
            }
            return nil
        }
        
        func hasParentMatching(_ matcher: (HasSwiftStyle)->Bool) -> Bool {
            return parentMatching(matcher) != nil
        }
        
        func meets(requirement: Requirement) -> Bool {
            switch requirement {
            case .focused:
                if #available(iOS 9.0, *) {
                    return objectIsFocused
                } else {
                    return false
                }
            case .highlighted:
                return objectIsHighlighted
            case .hasParent(let parentName):
                return hasParentMatching { $0.styleName == parentName }
            case .hasStyleName(let styleName):
                return object.styleName == styleName
            }
        }
    }
}
