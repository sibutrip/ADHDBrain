//
//  AssignTimeView.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/30/23.
//

import SwiftUI

struct AllTasksView: View {
    @ObservedObject var vm: ViewModel
    var body: some View {
        List(vm.tasks) { _ in
        }
    }
}

struct AllTasksView_Previews: PreviewProvider {
    static var previews: some View {
        AllTasksView(vm: ViewModel())
        AllTasksView(vm: ViewModel())
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
        
    }
}
