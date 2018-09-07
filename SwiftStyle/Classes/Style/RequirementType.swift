//
//  RequirementType.swift
//  SwiftStyle
//
//  Created by Patrik Sjöberg on 2018-09-06.
//

import Foundation

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
