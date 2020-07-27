//
//  ViewsAndModifiers.swift
//  GuessTheFlag
//
//  Created by Ramsey on 2020/5/27.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct ViewsAndModifiers: View {
    var motto1: some View { Text("Draco dormiens") }
    @State private var a = ""
    
    var body: some View {
//        VStack {
//            Text("Hello, World!")
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(Color.red)
//                .edgesIgnoringSafeArea(.all)
//        }
//        Button("Hello World") {
//            print(type(of: self.body))
//        }
//        .frame(width: 200, height: 200)
//        .background(Color.red)
//        Text("Hello World")
//        .padding()
//        .background(Color.red)
//        .padding()
//        .background(Color.blue)
//        .padding()
//        .background(Color.green)
//        .padding()
//        .background(Color.yellow)
        VStack {
            Text("Gryffindor")
                .blur(radius: 0)
            Text("Hufflepuff")
            Text("Ravenclaw")
            Text("Slytherin")
        }
        .blur(radius: 5)
    }
}

struct ViewsAndModifiers_Previews: PreviewProvider {
    static var previews: some View {
        ViewsAndModifiers()
    }
}
