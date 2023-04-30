//
//  TaskRow.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/29/23.
//

import SwiftUI

struct TaskRow: View {
    let task: Task
    let geo: GeometryProxy
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.blue).opacity(0.2)
            RoundedRectangle(cornerRadius: 10)
                .stroke()
            Text(task.name)
        }
        .frame(maxHeight: geo.size.height / 10)
        .modifier(SwipeGesture(geo, with: task))
    }
    init(_ task: Task, _ geo: GeometryProxy) {
        self.task = task
        self.geo = geo
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            TaskRow(Task(name: "woo"), geo)
        }
    }
}
