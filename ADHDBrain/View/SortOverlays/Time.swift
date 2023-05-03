//
//  Time.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 5/2/23.
//

import Foundation

struct Time: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let timeSelection: TimeSelection
    
    static let days: [Time] = [
        .init(name: "􀆱", image: "sunrise", timeSelection: .morning),
        .init(name: "􀆳", image: "sunset", timeSelection: .afternoon),
        .init(name: "􀆹", image: "moon", timeSelection: .evening)
    ]
    static let skips: [Time] = [
        .init(name: "1", image: "gobackward", timeSelection: .skip1),
        .init(name: "3", image: "gobackward", timeSelection: .skip3),
        .init(name: "7", image: "gobackward", timeSelection: .skip7)
    ]
}
