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
    @State var dropAction: TimeSelection = .noneSelected
    @State private var dragAction: DragTask = .init(isDragging: false, timeSelection: .noneSelected)
    
    var body: some View {
        GeometryReader { geo in
            
                ZStack {
                    VStack {
                        if vm.unsortedTasks > 0 {
                            ForEach(vm.tasks) { task in
                                if task.sortStatus == .unsorted {
                                    TaskRow(task, geo)
                                        .onPreferenceChange(DropPreference.self) {
                                            dropTask in
                                            vm.sortTask(for: dropTask)
                                        }
                                        .onPreferenceChange(DragPreference.self) { dragAction in
                                            if let dragAction = dragAction {
                                                self.dragAction = dragAction
                                            }
                                        }
                                }
                            }
                        } else {
                            Text("you have no unsorted tasks!")
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
                        .padding()
                    }
                    .animation(.default, value: vm.tasks)
                    .onAppear {
                        focusedField = .none
                    }
                    DayOverlay(geo: geo, dragAction: $dragAction)
                }
                .transition(.slide)
                .animation(.default, value: vm.tasks)
                .coordinateSpace(name: "SortView")
        }
    }
    
    func addTask() {
        if newTask.isEmpty {
            focusedField = .none
            return
        }
        vm.tasks.append(TaskItem(name: newTask))
        newTask.removeAll()
        focusedField = .newTask
    }
}

struct SortView_Previews: PreviewProvider {
    static var previews: some View {
        SortView(vm: ViewModel())
    }
}
