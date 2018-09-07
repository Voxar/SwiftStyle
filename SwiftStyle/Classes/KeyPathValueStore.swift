//
//  KeyPathValueStore.swift
//  SwiftStyle_Example
//
//  Created by Patrik Sjöberg on 2018-08-30.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

protocol TypeErasedValue {
    func apply(to object: inout Any)
}

struct KeyPathValueStore<T> {
    struct Value<T, V>: TypeErasedValue {
        let keyPath: WritableKeyPath<T, V>
        let value: V
        
        func apply(to object: inout Any) {
            if let typedObject = object as? T {
                object = apply(to: typedObject)
            }
        }
        
        func apply(to object: T) -> T {
            var object = object
            object[keyPath: keyPath] = value
            return object
        }
    }
    
    var storage: [PartialKeyPath<T>: TypeErasedValue] = [:]
    
    public init() {
    }
    
    public subscript<V>(key: WritableKeyPath<T, V>) -> V? {
        get {
            return (storage[key] as? Value<T, V>)?.value
        }
        set {
            if let value = newValue {
                storage[key] = Value<T, V>(keyPath: key, value: value)
            }
        }
    }
    
    public func apply(to object: inout T) {
        var anyObject: Any = object
        for value in storage.values {
            value.apply(to: &anyObject)
        }
        let typedObject = anyObject as! T
        object = typedObject
    }

}
