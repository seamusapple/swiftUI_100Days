//
//  HitTestView.swift
//  Flashzilla
//
//  Created by Ramsey on 2020/7/11.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct HitTestView: View {
    var body: some View {
        VStack {
            Text("Hello")
            Spacer().frame(height: 100)
            Text("World")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            print("VStack tapped!")
        }
//        ZStack {
//            Rectangle()
//                .fill(Color.blue)
//                .frame(width: 300, height: 300)
//                .onTapGesture {
//                    print("Rectangle tapped!")
//                }
//
//            Circle()
//                .fill(Color.red)
//                .frame(width: 300, height: 300)
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    print("Circle tapped!")
//                }
////                .allowsHitTesting(false)
//        }
    }
}

struct HitTestView_Previews: PreviewProvider {
    static var previews: some View {
        HitTestView()
    }
}
