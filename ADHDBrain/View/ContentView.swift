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
        ZStack {
            if vm.unsortedTasks > 0 {
                SortView(vm: vm)
            } else {
                AssignTimeView(vm: vm)
            }
        }
        .transition(.slide)
        .animation(.default, value: vm.tasks)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
