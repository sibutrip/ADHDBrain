//
//  ReadWrite.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 5/12/23.
//

import Foundation
import SwiftUI

@propertyWrapper
struct ReadWrite<T:Codable>: DynamicProperty {
    var projectedValue: [T] = []
    var wrappedValue: [T] {
        get {
            return projectedValue
        }
        set {
            self.projectedValue = newValue
            DirectoryService.writeModelToDisk(projectedValue)
        }
    }
}
