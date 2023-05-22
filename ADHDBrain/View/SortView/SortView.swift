//
//  SortView.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/29/23.
//

import SwiftUI

struct SortView: View {
    
    enum FocusedField {
        case showKeyboard, dismissKeyboard
    }
    
    @State private var newTask = ""
    @ObservedObject var vm: ViewModel
    @FocusState private var focusedField: FocusedField?
    @State var dropAction: TimeSelection = .noneSelected
    @State private var sortDidFail: Bool = false
    @State var taskToAdd = ""
    @Environment(\.editMode) var editMode
//    var isEditing: Bool {
//        editMode?.wrappedValue.
//    }
    
    func createTask() {
        if taskToAdd.isEmpty { return }
        vm.tasks.append(TaskItem(name: taskToAdd))
        taskToAdd.removeAll()
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<vm.unsortedTasks.count,id: \.self) { index in
                    let task = vm.unsortedTasks[index]
                    HStack {
                        Text(task.name)
                            .modifier(SortActions(task: task, vm: vm, index: index))
                    }
                }
                .onDelete { index in
                    vm.tasks.remove(atOffsets: index)
                }
                HStack {
                    TextField("add a task...", text: $taskToAdd)
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
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
            .environment(\.editMode, editMode)
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

struct SortView_Previews: PreviewProvider {
    static var previews: some View {
        SortView(vm: ViewModel())
    }
}
