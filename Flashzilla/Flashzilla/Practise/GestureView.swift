//
//  GestureView.swift
//  Flashzilla
//
//  Created by Ramsey on 2020/7/11.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

//struct GestureView: View {
//
//    @State private var currentAmount: CGFloat = 0
//    @State private var finalAmount: CGFloat = 1
//
//    @State private var currentRotateAmount: Angle = .degrees(0)
//    @State private var finalRotateAmount: Angle = .degrees(0)
//
//    var body: some View {
//        VStack {
//            Text("Hello, World!")
//                .onTapGesture {
//                    print("Text tapped")
//                }
//        }
////        .onTapGesture {
////            print("VStack tapped")
////        }
////        .highPriorityGesture(
////            TapGesture()
////                .onEnded { _ in
////                    print("VStack tapped")
////                }
////        )
//        .simultaneousGesture(
//            TapGesture()
//                .onEnded { _ in
//                    print("VStack tapped")
//                }
//        )
//    }
//
////    var body: some View {
////        Text("Hello, World!")
////            .scaleEffect(finalAmount + currentAmount)
////            .rotationEffect(currentRotateAmount + finalRotateAmount)
////            .gesture(
////                MagnificationGesture()
////                    .onChanged { amount in
////                        self.currentAmount = amount - 1
////                    }
////                    .onEnded { amount in
////                        self.finalAmount += self.currentAmount
////                        self.currentAmount = 0
////                    }
////            )
////            .gesture(
////                RotationGesture()
////                .onChanged { angle in
////                    self.currentRotateAmount = angle
////                }
////                .onEnded { angle in
////                    self.finalRotateAmount += self.currentRotateAmount
////                    self.currentRotateAmount = .degrees(0)
////                }
////            )
////        .onTapGesture(count: 2) {
////            print("Double tapped!")
////        }
////        .onLongPressGesture(minimumDuration: 2, maximumDistance: 4, pressing: { (inProgress) in
////            print("In Progress: \(inProgress)!")
////        }) {
////            print("Long Tapped!")
////        }
////    }
//}

struct GestureView: View {
    // how far the circle has been dragged
    @State private var offset = CGSize.zero

    // whether it is currently being dragged or not
    @State private var isDragging = false

    var body: some View {
        // a drag gesture that updates offset and isDragging as it moves around
        let dragGesture = DragGesture()
            .onChanged { value in self.offset = value.translation }
            .onEnded { _ in
                withAnimation {
                    self.offset = .zero
                    self.isDragging = false
                }
            }

        // a long press gesture that enables isDragging
        let pressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    self.isDragging = true
                }
            }

        // a combined gesture that forces the user to long press then drag
        let combined = pressGesture.sequenced(before: dragGesture)

        // a 64x64 circle that scales up when it's dragged, sets its offset to whatever we had back from the drag gesture, and uses our combined gesture
        return Circle()
            .fill(Color.red)
            .frame(width: 64, height: 64)
            .scaleEffect(isDragging ? 1.5 : 1)
            .offset(offset)
            .gesture(combined)
    }
}
struct GestureView_Previews: PreviewProvider {
    static var previews: some View {
        GestureView()
    }
}
