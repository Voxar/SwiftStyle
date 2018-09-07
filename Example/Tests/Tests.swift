// https://github.com/Quick/Quick

import Quick
import Nimble
@testable import SwiftStyle

class KeyPathValueStorageSpec: QuickSpec {
    
    class ClassSubject {
        var property: String = "Hello"
        var int: Int = 0
    }
    
    class SubClassSubject: ClassSubject {
        var subclassProperty: Float = 0
    }
    
    struct StructSubject {
        var property: String? = "Hello"
        var int: Int = 0
    }
    
    override func spec() {
        describe("storing and applying values") {
            
            it("can store and apply to class types") {
                var store = KeyPathValueStore<ClassSubject>()
                
                store[\.property] = "World"
                store[\.int] = 22
                
                var subject = ClassSubject()
                store.apply(to: &subject)
                expect(subject.property).to(equal("World"))
                expect(subject.int).to(equal(22))
            }
            
            it("can store and apply to class types with inheritance") {
                var store = KeyPathValueStore<SubClassSubject>()
                
                store[\.property] = "World"
                store[\.int] = 22
                store[\.subclassProperty] = 1234.5678
                
                var subject = SubClassSubject()
                store.apply(to: &subject)
                expect(subject.property).to(equal("World"))
                expect(subject.int).to(equal(22))
                expect(subject.subclassProperty).to(equal(1234.5678))
            }
            
            it("can store and apply to struct types") {
                
                var store = KeyPathValueStore<StructSubject>()
                store[\.property] = "World"
                store[\.int] = 22
                
                var subject = StructSubject()
                store.apply(to: &subject)
                expect(subject.property).to(equal("World"))
                expect(subject.int).to(equal(22))
            }

        }
    }
}
