//
//  EditModeModifier.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 5/22/23.
//

import Foundation
import SwiftUI

struct DeleteActions: ViewModifier {
    
    let index: Int
    let task: TaskItem
    @ObservedObject var vm: ViewModel
    
    func body(content: Content) -> some View {
        content
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button {
                    vm.tasks.remove(at: index)
                } label:{
                    Label("Skip 1", image: "trash")
                }
                .tint(.red)
            }
    }
}
