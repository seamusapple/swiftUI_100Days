//
//  ContactView.swift
//  ConsolidationVI
//
//  Created by Ramsey on 2020/7/6.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct ContactView: View {
    var contact: Contact

    var body: some View {
        HStack(spacing: 20) {
            contact.getAvatar()
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipped()
                .cornerRadius(10)
                .foregroundColor(.gray)
            Text(contact.name)
        }
    }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView(contact: Contact.example)
    }
}
