//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Ramsey on 2020/7/19.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct User: Identifiable {
    var id = "Taylor Swift"
}

struct ContentView: View {
    
    @State private var selectedUser: User? = nil
    @State private var layoutVertically = false
    @Environment(\.horizontalSizeClass) var sizeClass

    var body: some View {
//        NavigationView {
//            NavigationLink(destination: Text("New secondary")) {
//                Text("Hello, World!")
//            }
//            .navigationBarTitle("Primary")
//
//            Text("Secondary")
//        }
        
//        Text("Hello, World!")
//            .onTapGesture {
//                self.selectedUser = User()
//            }
//            .alert(item: $selectedUser) { user in
//                Alert(title: Text(user.id))
//            }
        
//        Group {
//            if layoutVertically {
//                VStack {
//                    UserView()
//                }
//            } else {
//                HStack {
//                    UserView()
//                }
//            }
//        }
//        .onTapGesture {
//            self.layoutVertically.toggle()
//        }
        
        Group {
//            if sizeClass == .compact {
//                VStack {
//                    UserView()
//                }
//            } else {
//                HStack {
//                    UserView()
//                }
//            }
            if sizeClass == .compact {
                VStack(content: UserView.init)
            } else {
                HStack(content: UserView.init)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
