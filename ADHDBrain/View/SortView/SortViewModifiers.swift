//
//  SortViewModifiers.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 5/22/23.
//

import Foundation
import SwiftUI

struct SortViewModifiers: ViewModifier {
    let task: TaskItem
    @ObservedObject var vm: ViewModel
    func body(content: Content) -> some View {
        content
            .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button {
                Task { await vm.sortTask(task, at: .skip1) }
            } label:{
                Label("Skip 1", image: "backward.1")
            }
            .tint(.red)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button {
                Task { await vm.sortTask(task, at: .skip3) }
            } label: {
                Label("Skip 3", image: "backward.3")
            }
            .tint(.red)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button {
                Task { await vm.sortTask(task, at: .skip7) }
            } label: {
                Label("Skip 7", image: "backward.7")
            }
            .tint(.red)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                // TODO: add functionality
            } label: {
                Label("Evening", systemImage: "moon")
            }
            .tint(.indigo)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                // TODO: add functionality
            } label: {
                Label("Afternoon", systemImage: "sunset")
            }
            .tint(.cyan)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                // TODO: add functionality
            } label: {
                Label("Morning", systemImage: "sunrise")
            }
            .tint(.yellow)
        }
    }
}
