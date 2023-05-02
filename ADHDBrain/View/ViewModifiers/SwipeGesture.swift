//
//  SwipeGesture.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/30/23.
//

import Foundation
import SwiftUI

struct SwipeGesture: ViewModifier {
    let task: Task
    
    let geo: GeometryProxy

    @State private var offset: CGSize = .zero
    @State private var dropPreference: DropPreference? // doess this need to be optional?
    @State private var dropState: TimeSelection = .noneSelected
    
    @State private var dragPreference = DragPreference()
    @State private var dragState: TimeSelection = .noneSelected
    @State private var isDragging: Bool = false
    
    @State var locationWidth: CGFloat = .zero
    @State var locationHeight: CGFloat = .zero
    
    let top: CGFloat
    let center: CGFloat
    let bottom: CGFloat
    let leading: CGFloat
    let trailing: CGFloat
    
    func body(content: Content) -> some View {
        content
            .offset(offset)
            .gesture(
                DragGesture(coordinateSpace: .named("SortView"))
                    .onChanged { value in
                        isDragging = true
                        offset = value.translation
                        locationHeight = value.location.y
                        locationWidth = value.location.x
                        if locationWidth <  leading {
                            // leading edge of screen
                            if locationHeight < top {
                                dragState = .skip1
                            } else if locationHeight < center {
                                dragState = .skip3
                            } else {
                                dragState = .skip7
                            }
                        } else if locationWidth < trailing {
                            // middle of screen
                            dragState = .noneSelected
                        } else {
                            // trailing edge of screen
                            if locationHeight < top {
                                dragState = .morning
                            } else if locationHeight < center {
                                dragState = .afternoon
                            } else {
                                dragState = .evening
                            }
                        }
                    }
                    .onEnded { value in
                        dropState = dragState
                        dragState = .noneSelected
                        isDragging = false
                        offset = .zero
                    }
            )
            .preference(key: DropPreference.self, value: DropTask(task: task, dropAction: dropState))
            .preference(key: DragPreference.self, value: DragTask(isDragging: isDragging, timeSelection: dragState))
    }
    
    init(_ geo: GeometryProxy, with task: Task) {
        self.task = task
        self.geo = geo
        top = geo.size.height / 3
        center = 2 * geo.size.height / 3
        bottom = geo.size.height
        leading = geo.size.height / 3 - geo.size.height / 4
        trailing = geo.size.width - geo.size.height / 3 + geo.size.height / 4
    }
}
