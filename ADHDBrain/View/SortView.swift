//
//  SortView.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/29/23.
//

import SwiftUI


struct SortView: View {
    enum FocusedField {
        case newTask
    }
    @State private var newTask = ""
    @ObservedObject var vm: ViewModel
    @FocusState private var focusedField: FocusedField?
    @State var dropAction: DropAction = .noDrop
    @State private var isDragging = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    ForEach(vm.tasks) { task in
                        if task.sortStatus == .unsorted {
                            TaskRow(task, geo)
                                .onPreferenceChange(DropPreference.self) {
                                    taskDrop in
                                    vm.sortTask(for: taskDrop)
                                }
                                .onPreferenceChange(DragPreference.self) { isDragging in
                                    if let isDragging = isDragging {
                                        self.isDragging = isDragging
                                    }
                                }
                        }
                    }
                    HStack {
                        TextField("new task", text: $newTask)
                            .textFieldStyle(.roundedBorder)
                            .focused($focusedField, equals: .newTask)
                            .onSubmit {
                                addTask()
                            }
                        Button {
                            addTask()
                        } label: {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.green)
                        }
                    }
                }
                .animation(.default, value: vm.tasks)
                .onAppear {
                    focusedField = .none
                }
                DayOverlay(geo: geo, isDragging: $isDragging)
            .padding()
            }
        }
    }
    
    func addTask() {
        if newTask.isEmpty {
            focusedField = .none
            return
        }
        vm.tasks.append(Task(name: newTask))
        newTask.removeAll()
        focusedField = .newTask
    }
}

struct SortView_Previews: PreviewProvider {
    static var previews: some View {
        SortView(vm: ViewModel())
    }
}
