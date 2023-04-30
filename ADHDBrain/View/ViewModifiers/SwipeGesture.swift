//
//  SwipeGesture.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/30/23.
//

import Foundation
import SwiftUI

struct SwipeGesture: ViewModifier {
    let geo: GeometryProxy
    let task: Task
    
    @State private var rotationDegrees: Double = 0
    @State private var xOffset: Double = 0
    @State private var swipePreference: SwipePreference?
    @State private var swipeDirection: SwipeDirection = .notSwiped
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: rotationDegrees))
            .offset(x: CGFloat(xOffset), y: 0)
            .gesture(
            DragGesture()
                .onChanged { value in
                    xOffset = value.translation.width
                    rotationDegrees = xOffset / geo.size.width * 10
                }
                .onEnded { value in
                    if value.predictedEndTranslation.width > geo.size.width / 3 {
                        swipeDirection = .right
                    } else if abs(value.predictedEndTranslation.width) > geo.size.width / 3 {
                        swipeDirection = .left
                    } else {
                        swipeDirection = .notSwiped
                        xOffset = 0
                        rotationDegrees = 0
                    }
                }
            )
            .preference(key: SwipePreference.self, value: TaskSwipe(task: task, swipeDiretion: swipeDirection))
    }
    
    init(_ geo: GeometryProxy, with task: Task) {
        self.geo = geo
        self.task = task
    }
}
