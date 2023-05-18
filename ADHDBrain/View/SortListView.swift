//
//  SortListView.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/29/23.
//

import SwiftUI

struct SortListView: View {
    
    @StateObject var dragManager = DragManager()
    
    
    enum FocusedField {
        case showKeyboard, dismissKeyboard
    }
    @State private var newTask = ""
    @ObservedObject var vm: ViewModel
    @FocusState private var focusedField: FocusedField?
    @State var dropAction: TimeSelection = .noneSelected
    @State private var dragAction: DragTask = .init(isDragging: false, timeSelection: .noneSelected, keyboardSelection: .dismissKeyboard)
    @State private var sortDidFail: Bool = false
    
    var body: some View {
        NavigationStack {
            List(vm.tasks) { task in
                Text(task.name)
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        Button {
                            // TODO: add functionality
                        } label: {
                            Label {
                                Text("woo")
                            } icon: {
                                ZStack {
                                    Text("uWu")
                                    Text("ooh")
                                }
                            }

//                            Label("Delete", systemImage: "1.circle")
                        }
                        .tint(.red)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        Button {
                            // TODO: add functionality
                        } label: {
                            Label("Delete", systemImage: "3.circle")
                        }
                        .tint(.red)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        Button {
                            // TODO: add functionality
                        } label: {
                            Label("Delete", systemImage: "gobackward")
                        }
                        .tint(.red)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            // TODO: add functionality
                        } label: {
                            Label("Delete", systemImage: "moon")
                        }
                        .tint(.indigo)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            // TODO: add functionality
                        } label: {
                            Label("Delete", systemImage: "sunset")
                        }
                        .tint(.cyan)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            // TODO: add functionality
                        } label: {
                            Label("Delete", systemImage: "sunrise")
                        }
                        .tint(.yellow)
                    }
            }
            .navigationTitle("Sort Tasks")
        }
    }
    
    func addTask() {
        if newTask.isEmpty {
            focusedField = .dismissKeyboard
            print("dismessied")
            return
        }
        vm.tasks.append(TaskItem(name: newTask))
        newTask.removeAll()
        focusedField = .showKeyboard
    }
}

struct SortListView_Previews: PreviewProvider {
    static var previews: some View {
        SortListView(vm: ViewModel())
    }
}
