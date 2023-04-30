//
//  ContentView.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/30/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ViewModel()
    var body: some View {
        if vm.unsortedTasks > 0 {
            SortView(vm: vm)
                .onPreferenceChange(DragPreference.self) { value in
                    guard let value = value else { return }
//                    isDragging = value
                    print(value)
                }
        } else {
            AssignTimeView(vm: vm)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
