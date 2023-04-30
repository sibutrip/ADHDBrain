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
    
    @State private var offset: CGSize = .zero
    @State private var dropPreference: DropPreference? // doess this need to be optional?
    @State private var dropAction: DropAction = .noDrop
    
    @State private var dragPreference = DragPreference()
    @State private var dragState: Bool = false
    
    func body(content: Content) -> some View {
        content
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = value.translation
                        dragState = true
                    }
                    .onEnded { value in
                        dragState = false
                        let locationHeight = value.predictedEndLocation.y
                        let locationWidth = value.predictedEndLocation.x
                        if (locationWidth) < (geo.size.width - geo.size.height / 3 + geo.size.height / 5) {
                            offset = .zero
                            dropAction = .noDrop
                            return
                        }
                        if (locationHeight + geo.size.height / 2) < geo.size.height / 3 {
                            dropAction = .morning
                            print("morning")
                        } else if (locationHeight + geo.size.height / 2) < 2 * geo.size.height / 3 {
                            dropAction = .afternoon
                            print("afternoon")
                        } else {
                            dropAction = .evening
                            print("eve")
                        }
                    }
            )
            .preference(key: DropPreference.self, value: TaskDrop(task: task, dropAction: dropAction))
            .preference(key: DragPreference.self, value: dragState)
    }
    
    init(_ geo: GeometryProxy, with task: Task) {
        self.geo = geo
        self.task = task
    }
}
