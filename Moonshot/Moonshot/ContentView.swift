//
//  ContentView.swift
//  Moonshot
//
//  Created by Ramsey on 2020/6/7.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct CustomText: View {
    var text: String

    var body: some View {
        Text(text)
    }

    init(_ text: String) {
        print("Creating a new CustomText")
        self.text = text
    }
}

struct User: Codable {
    var name: String
    var address: Address
}

struct Address: Codable {
    var street: String
    var city: String
}

struct ContentView: View {
    var body: some View {
//        GeometryReader { g in
//            Image("cat")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: g.size.width)
//        }
//        ScrollView(.vertical) {
//            VStack(spacing: 10) {
//                ForEach(0..<100) {
////                    Text("Item \($0)")
////                        .font(.title)
//                    CustomText("Item \($0)")
//                        .font(.title)
//                }
//            }
//            .frame(maxWidth: .infinity)
//        }
//        List {
//            ForEach(0..<100) {
//                CustomText("Item \($0)")
//                    .font(.title)
//            }
//        }
//        NavigationView {
////            VStack {
////                NavigationLink(destination: Text("Destionation")) {
////                    Text("Hello World")
////                }
////            }
//            List(0..<100) { row in
//                NavigationLink(destination: Text("Detail \(row)")) {
//                    Text("Row \(row)")
//                }
//            }
//            .navigationBarTitle("SwiftUI")
//        }
        
        Button("Decode JSON") {
            let input = """
            {
                "name": "Taylor Swift",
                "address": {
                    "street": "555, Taylor Swift Avenue",
                    "city": "Nashville"
                }
            }
            """

            let data = Data(input.utf8)
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: data) {
                print(user.address.street)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
