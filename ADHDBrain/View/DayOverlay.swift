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
    static let days: [Day] = [.init(name: "􀆱", image: "sunrise"),
                              .init(name: "􀆳", image: "sunset"),
                              .init(name: "􀆹", image: "moon")]
}

struct DayOverlay: View {
    let days = Day.days
    let geo: GeometryProxy
    
    @State private var dragPreference = DragPreference()
    @Binding var isDragging: Bool
    
    var body: some View {
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
            }
        }
        
        .frame(width: geo.size.width, height: geo.size.height)
        .offset(x: isDragging ? 0 : geo.size.width * 0.1)
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
