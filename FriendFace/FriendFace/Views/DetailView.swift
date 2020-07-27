//
//  DetailView.swift
//  FriendFace
//
//  Created by Ramsey on 2020/6/21.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    
    var user: User
    
    var body: some View {
        List {
            Section(header: Text("Name")) {
                Text(user.uName)
            }
            Section(header: Text("Age")) {
                Text(String(user.age))
            }
            Section(header: Text("Company")) {
                Text(user.uCompanyName)
            }
            Section(header: Text("Email")) {
                Text(user.uEmail)
            }
            Section(header: Text("Address")) {
                Text(user.uAddress)
            }
            Section(header: Text("Friends")) {
                ForEach(user.friendsArray, id: \.id) { friend in
                    NavigationLink(destination: DetailView(user: friend)) {
                        VStack(alignment: HorizontalAlignment.leading) {
                            Text(friend.uName)
                                .font(.headline)
                            Text(friend.uEmail)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("\(user.uName)", displayMode: .inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var ramsey: User {
        let user = User()
        user.name = "Ramsey Pan"
        user.age = 54
        user.email = "ramsey.pan@apple.com"
        user.address = "Cupertino"

        let company = Company()
        company.name = "Apple"
        user.company = company

        return user
    }
    
    static var previews: some View {
        DetailView(user: ramsey)
    }
}
