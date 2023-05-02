//
//  AssignTimeView.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/30/23.
//

import SwiftUI

struct AssignTimeView: View {
    @ObservedObject var vm: ViewModel
    var body: some View {
        Text("Hello, World!")
    }
}

struct AssignTimeView_Previews: PreviewProvider {
    static var previews: some View {
        AssignTimeView(vm: ViewModel())
        AssignTimeView(vm: ViewModel())
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
        
    }
}
