//
//  TestView.swift
//  iExpense
//
//  Created by Ramsey on 2020/6/6.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

class User: ObservableObject {
    @Published var firstName = "Bilbo"
    @Published var lastName = "Baggins"
}

struct UserOne: Codable {
    var firstName = "Bilbo"
    var lastName = "Baggins"
}

struct SecondView: View {
    @ObservedObject var user: User
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Your name is \(user.firstName) \(user.lastName).")

            TextField("First name", text: $user.firstName)
            TextField("Last name", text: $user.lastName)
            
            Button("Dismiss") {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct TestView: View {
    @ObservedObject var user = User()
    @State private var showingSheet = false
    @State private var numbers = [Int]()
    @State private var currentNumber = 1
    @State private var tapCount = UserDefaults.standard.integer(forKey: "Tap")
    @State private var userOne = UserOne(firstName: "Taylor", lastName: "Swift")
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Your name is \(user.firstName) \(user.lastName).")
                
                Button("Show sheet") {
                    self.showingSheet.toggle()
                }
                .sheet(isPresented: $showingSheet) {
                    SecondView(user: self.user)
                }
                
                List {
                    ForEach(numbers, id: \.self) {
                        Text("\($0)")
                    }
                    .onDelete(perform: removeRows)
                }

                Button("Add Number") {
                    self.numbers.append(self.currentNumber)
                    self.currentNumber += 1
                }
                
                Button("Tap count: \(tapCount)") {
                    self.tapCount += 1
                    UserDefaults.standard.set(self.tapCount, forKey: "Tap")
                }
                
                Button("Save User") {
                    let encoder = JSONEncoder()

                    if let data = try? encoder.encode(self.userOne) {
                        UserDefaults.standard.set(data, forKey: "UserData")
                    }
                }
                
                Button("Show User") {
                    let decoder = JSONDecoder()
                    guard let userOneData = UserDefaults.standard.object(forKey: "UserData") as? Data else { return }
                    if let data = try? decoder.decode(UserOne.self, from: userOneData) {
                        self.user.firstName = data.firstName
                        self.user.lastName = data.lastName
                    }
                }
            }
            .navigationBarItems(leading: EditButton())
        }
    }
        
    
    func removeRows(at offsets: IndexSet) {
        numbers.remove(atOffsets: offsets)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

