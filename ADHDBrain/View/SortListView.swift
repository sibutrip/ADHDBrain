//
//  SortListView.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/29/23.
//

import SwiftUI

struct SortListView: View {
    
    enum FocusedField {
        case showKeyboard, dismissKeyboard
    }
    
    @State private var newTask = ""
    @ObservedObject var vm: ViewModel
    @FocusState private var focusedField: FocusedField?
    @State var dropAction: TimeSelection = .noneSelected
    @State private var sortDidFail: Bool = false
    @State var taskToAdd = ""
    
    func createTask() {
        if taskToAdd.isEmpty { return }
        vm.tasks.append(TaskItem(name: taskToAdd))
        taskToAdd.removeAll()
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.unsortedTasks) { task in
                    Text(task.name)
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
                HStack {
                    TextField("add a task...", text: $taskToAdd)
                    //                                .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            createTask()
                        }
                    Button {
                        createTask()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            .overlay {
                if vm.unsortedTasks.count == 0 {
                    Text("You have no unsorted tasks!")
                } else {
                    EmptyView()
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
