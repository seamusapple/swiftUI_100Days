//
//  MainView.swift
//  ConsolidationVI
//
//  Created by Ramsey on 2020/7/6.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var addressBook = AddressBook()
    @State private var showingAddContactView = false
    
    var body: some View {
        NavigationView {
            List() {
                ForEach(addressBook.contacts) { contact in
                    NavigationLink(destination: DetailView(contact: contact)) {
                        ContactView(contact: contact)
                    }
                }
                .onDelete(perform: self.performDelete(at:))
            }
            .navigationBarTitle("Event Contacts")
            .navigationBarItems(
                leading: EditButton(),
                trailing:
                    Button(
                        action: {
                        self.showingAddContactView.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    }
                )
            )
        }
        .sheet(isPresented: $showingAddContactView) {
            AddContactView(addressBook: self.addressBook)
        }
    }
    
    private func performDelete(at offsets: IndexSet) {
        self.addressBook.remove(atOffsets: offsets)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
