//
//  ContentView.swift
//  FriendFace
//
//  Created by Ramsey on 2020/6/21.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @State var filteredType = PredicateType.noFilter
    @State var isFiltered: Bool = false
    let filterValueArray = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    @State var filterValue = "A"
    
    private var sortBy = [NSSortDescriptor(key: "name", ascending: true)]
    
    var body: some View {
        NavigationView {
            FilteredList(in: moc, filterKey: "name", predicateType: filteredType, filterValue: filterValue, sortDescriptors: sortBy) { (user: User) in
                NavigationLink(destination: DetailView(user: user)) {
                    VStack(alignment: HorizontalAlignment.leading, spacing: 5) {
                        Text(user.uName)
                            .font(.headline)
                        Text(user.uEmail)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(user.tagsArray[0])
                            .font(.subheadline)
                            .clipShape(Rectangle())
                            .foregroundColor(.black)
                            .background(Color.green)
                    }
                }
            }
            .navigationBarTitle("Users")
            .navigationBarItems(trailing:
                HStack {
                    Button(action: {
                        self.isFiltered.toggle()
                        if self.isFiltered {
                            self.filteredType = PredicateType.beginsWith
                        } else {
                            self.filteredType = .noFilter
                        }
                    }, label: {
                        if self.isFiltered {
                            Text("Clear Filters")
                        } else {
                            Text("Filter ")
                        }
                    })
                    
                    Button(action: {
                        self.filterValue = self.filterValueArray.randomElement() ?? "A"
                    }, label: {
                        Text(filterValue)
                    })
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
