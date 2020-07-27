//
//  Geometry.swift
//  LayoutAndGeometry
//
//  Created by Ramsey on 2020/7/12.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct OuterView: View {
    var body: some View {
        VStack {
            Text("Top")
            InnerView()
                .background(Color.green)
            Text("Bottom")
        }
    }
}

struct InnerView: View {
    var body: some View {
        HStack {
            Text("Left")
            GeometryReader { geo in
                Text("Center")
                    .background(Color.blue)
                    .onTapGesture {
                        print("Global center: \(geo.frame(in: .global).midX) x \(geo.frame(in: .global).midY)")
                        print("Custom center: \(geo.frame(in: .named("Custom")).midX) x \(geo.frame(in: .named("Custom")).midY)")
                        print("Local center: \(geo.frame(in: .local).midX) x \(geo.frame(in: .local).midY)")
                    }
            }
            .background(Color.orange)
            Text("Right")
        }
    }
}

struct Geometry: View {
    var body: some View {
//        Text("Hello, World!")
//            .offset(x: 100, y: 100)
//            .background(Color.red)
//            .position(CGPoint(x: 100, y: 100))

//        GeometryReader { geo in
//            Text("Hello, World!")
//                .frame(width: geo.size.width * 0.9)
//                .background(Color.red)
//        }
        
//        VStack {
//            GeometryReader { geo in
//                Text("Hello, World!")
//                    .frame(width: geo.size.width * 0.9, height: 40)
//                    .background(Color.red)
//            }
//            .background(Color.green)
//
//            Text("More text")
//                .background(Color.blue)
//        }
//        .background(Color.yellow)
        
        OuterView()
            .background(Color.red)
            .coordinateSpace(name: "Custom")
    }
}

struct Geometry_Previews: PreviewProvider {
    static var previews: some View {
        Geometry()
    }
}
