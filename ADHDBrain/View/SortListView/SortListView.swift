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
    @FocusState private var isFocused
    @State var dropAction: TimeSelection = .noneSelected
    @State private var dragAction: DragTask = .init(isDragging: false, timeSelection: .noneSelected, keyboardSelection: .dismissKeyboard)
    @State private var sortDidFail: Bool = false
    @State private var disclosureExpanded: Set<UUID> = []
    @State private var disclosure: Bool = false
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<vm.tasks.count, id: \.self) { index in
                    let task = vm.tasks[index]
                    SortListDisclosure(vm, task, $disclosureExpanded)
                }
                .onDelete { index in
                    vm.tasks.remove(atOffsets: index)
                }
                HStack {
                    TextField("new task", text: $newTask)
                        .focused($isFocused)
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
            .navigationTitle("Sort Tasks")
        }
    }
    
    func addTask() {
        if newTask.isEmpty {
            isFocused = false
            return
        }
        vm.tasks.append(TaskItem(name: newTask))
        newTask.removeAll()
        isFocused = true
    }
}

struct SortListView_Previews: PreviewProvider {
    static var previews: some View {
        SortListView(vm: ViewModel())
    }
}
