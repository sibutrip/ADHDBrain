//
//  SortView.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/29/23.
//

import SwiftUI


struct SortView: View {
    
    @StateObject var dragManager = DragManager()
    #warning("swipe down to dismiss keyboard")

    enum FocusedField {
        case newTask
    }
    @State private var newTask = ""
    @ObservedObject var vm: ViewModel
    @FocusState private var focusedField: FocusedField?
    @State var dropAction: TimeSelection = .noneSelected
    @State private var dragAction: DragTask = .init(isDragging: false, timeSelection: .noneSelected)
    @State private var sortDidFail: Bool = false
    
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
                                        Task {
                                            do {
                                                try await vm.sortTask(dropTask)
                                            } catch {
                                                print("sort is full")
                                                DragManager.sortDidFail = true
                                                sortDidFail = true
                                            }
                                        }
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
            .alert("Schedule is full", isPresented: $sortDidFail) {
                Button("ok") {
                    sortDidFail = false
                    DragManager.sortDidFail = false
                }
            }
            .transition(.slide)
            .animation(.default, value: vm.tasks)
            .coordinateSpace(name: "SortView")
            .environmentObject(dragManager)
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
