//
//  UserView.swift
//  SnowSeeker
//
//  Created by Ramsey on 2020/7/19.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct UserView: View {
    var body: some View {
        Group {
            Text("Name: Paul")
            Text("Country: England")
            Text("Pets: Luna, Arya, and Toby")
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
