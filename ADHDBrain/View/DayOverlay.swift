//
//  DayOverlay.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/30/23.
//

import SwiftUI

struct Day: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let timeSelection: TimeSelection
    static let days: [Day] = [.init(name: "􀆱", image: "sunrise", timeSelection: .morning),
                              .init(name: "􀆳", image: "sunset", timeSelection: .afternoon),
                              .init(name: "􀆹", image: "moon", timeSelection: .evening)]
    static let skipDay = Day(name: "skip", image: "x.circle", timeSelection: .skip)
}

struct DayOverlay: View {
    let days = Day.days
    let geo: GeometryProxy
    let skipDay = Day.skipDay
    
    @State private var dragPreference = DragPreference()
    @Binding var dragAction: DragTask
    
    var isDragging: Bool {
        dragAction.isDragging
    }
    
    var timeSelection: TimeSelection {
        return dragAction.timeSelection
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ForEach(days) { day in
                    Circle()
                        .foregroundColor(.blue)
                        .opacity(isDragging ? 0.2 : 0.0)
                        .frame(width: geo.size.width, alignment: .trailing)
                        .offset(x: geo.size.height / 5)
                        .overlay {
                            HStack {
                                Spacer()
                                Image(systemName: day.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width / 8, alignment: .trailing)
                            }
                            .padding(.trailing, 20)
                        }
                        .opacity(isDragging ? 1.0 : 0.0)
                        .offset(x: timeSelection == day.timeSelection ? geo.size.width / -10: 0)
                        .animation(.easeOut, value: timeSelection)
                }
            }
            .offset(x: isDragging ? 0 : geo.size.width * 0.1)
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: geo.size.height / 3)
                Circle()
                    .foregroundColor(.red)
                    .opacity(isDragging ? 0.2 : 0.0)
                    .frame(width: geo.size.width, alignment: .leading)
                    .offset(x: -geo.size.height / 5)
                    .overlay {
                        HStack {
                            Image(systemName: skipDay.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width / 8, alignment: .leading)
                            Spacer()
                        }
                        .padding(.leading, 20)
                    }
                    .opacity(isDragging ? 1.0 : 0.0)
                    .offset(x: timeSelection == skipDay.timeSelection ? geo.size.width / -10: 0)
                    .animation(.easeOut, value: timeSelection)
                Spacer()
                    .frame(height: geo.size.height / 3)
            }
            .offset(x: isDragging ? 0 : geo.size.width * -0.1)

        }
        
        .frame(width: geo.size.width, height: geo.size.height)
        .animation(.easeOut, value: isDragging)
    }
}

//struct DayOverlay_Previews: PreviewProvider {
//    static var previews: some View {
//        GeometryReader { geo in
//            DayOverlay(geo, true)
//        }
//    }
//}
