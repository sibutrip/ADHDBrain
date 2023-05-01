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
    @State private var dropState: TimeSelection = .noneSelected
    
    @State private var dragPreference = DragPreference()
    @State private var dragState: TimeSelection = .noneSelected
    @State private var isDragging: Bool = false
    
    func body(content: Content) -> some View {
        content
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        offset = value.translation
//                        print(geo.size.height)
//                        print(geo.size.width)
                        let locationHeight = value.location.y
                        let locationWidth = value.location.x
                        if (locationWidth) < (geo.size.width - geo.size.height / 3 + geo.size.height / 5) {
                            dragState = .noneSelected
                            return
                        }
                        if (locationHeight + geo.size.height / 2) < geo.size.height / 3  {
                            dragState = .morning
                        } else if (locationHeight + geo.size.height / 2) < 2 * geo.size.height / 3{
                            dragState = .afternoon
                        } else {
                            dragState = .evening
                        }
                    }
                    .onEnded { value in
                        dragState = .noneSelected
                        isDragging = false
                        let locationHeight = value.location.y
                        let locationWidth = value.location.x
                        
                        if locationWidth < (geo.size.height / 3 + geo.size.height / 5) && (locationHeight + geo.size.height / 2) < 2 * geo.size.height / 3 && (locationHeight + geo.size.height / 2) > geo.size.height / 3 {
                            dropState = .skip
                            print("skip")
                        } else if (locationWidth) < (geo.size.width - geo.size.height / 3 + geo.size.height / 5) {
                            offset = .zero
                            dropState = .noneSelected
                            return
                        } else if (locationHeight + geo.size.height / 2) < geo.size.height / 3 {
                            dropState = .morning
                            print("morning")
                        } else if (locationHeight + geo.size.height / 2) < 2 * geo.size.height / 3 {
                            dropState = .afternoon
                            print("afternoon")
                        } else {
                            dropState = .evening
                            print("eve")
                        }
                    }
            )
            .preference(key: DropPreference.self, value: DropTask(task: task, dropAction: dropState))
            .preference(key: DragPreference.self, value: DragTask(isDragging: isDragging, timeSelection: dragState))
    }
    
    init(_ geo: GeometryProxy, with task: Task) {
        self.geo = geo
        self.task = task
    }
}
