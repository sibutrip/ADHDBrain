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
    @State private var disclosureExpanded: Set<UUID> = []
    @State private var disclosure: Bool = false
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.tasks) { task in
                    SortListDisclosure(vm, task, $disclosureExpanded)
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
