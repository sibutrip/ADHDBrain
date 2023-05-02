//
//  DayOverlay.swift
//  ADHDBrain
//
//  Created by Cory Tripathy on 4/30/23.
//

import SwiftUI

struct Time: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let timeSelection: TimeSelection
    
    static let days: [Time] = [.init(name: "􀆱", image: "sunrise", timeSelection: .morning),
                               .init(name: "􀆳", image: "sunset", timeSelection: .afternoon),
                               .init(name: "􀆹", image: "moon", timeSelection: .evening)]
    static let skips: [Time] = [.init(name: "1", image: "gobackward", timeSelection: .skip1),
                                .init(name: "3", image: "gobackward", timeSelection: .skip3),
                                .init(name: "7", image: "gobackward", timeSelection: .skip7)]
}

struct DayOverlay: View {
    let days = Time.days
    let geo: GeometryProxy
    let skips = Time.skips
    
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
                        .offset(x: geo.size.height / 4)
                        .overlay {
                            HStack {
                                Spacer()
                                Image(systemName: day.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width / 10, alignment: .trailing)
                            }
                            .padding(.trailing, 10)
                        }
                        .opacity(isDragging ? 1.0 : 0.0)
                        .offset(x: timeSelection == day.timeSelection ? geo.size.width / -20: 0)
                        .animation(.easeOut, value: timeSelection)
                }
            }
            .offset(x: isDragging ? 0 : geo.size.width * 0.1)
            
            VStack(spacing: 0) {
                ForEach(skips) { skip in
                    Circle()
                        .foregroundColor(.red)
                        .opacity(isDragging ? 0.2 : 0.0)
                        .frame(width: geo.size.width, alignment: .leading)
                        .offset(x: -geo.size.height / 4)
                        .overlay {
                            HStack {
                                Image(systemName: skip.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.width / 10, alignment: .leading)
                                    .overlay { Text(skip.name) }
                                Spacer()
                            }
                            .padding(.leading, 10)
                        }
                        .opacity(isDragging ? 1.0 : 0.0)
                        .offset(x: timeSelection == skip.timeSelection ? geo.size.width / 20: 0)
                        .animation(.easeOut, value: timeSelection)
                    
                }
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
