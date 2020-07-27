//
//  SingerView.swift
//  CoreDataProject
//
//  Created by Ramsey on 2020/6/21.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct SingerView: View {
    
    @Environment(\.managedObjectContext) var moc
    @State private var lastNameFilter = "A"
    
    private var sortBy = [NSSortDescriptor(key: "lastName", ascending: true)]
    
    var body: some View {
        VStack {
            NavigationView {
                FilteredList(filterKey: "lastName", predicateType: .beginsWith, filterValue: lastNameFilter, sortDescriptors: sortBy) { (singer: Singer) in
                    Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
                }
            }
            
            Button("Add Examples") {
                let taylor = Singer(context: self.moc)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"

                let ed = Singer(context: self.moc)
                ed.firstName = "Ed"
                ed.lastName = "Sheeran"

                let adele = Singer(context: self.moc)
                adele.firstName = "Adele"
                adele.lastName = "Adkins"
                
                let ramsey = Singer(context: self.moc)
                ramsey.firstName = "Ramsey"
                ramsey.lastName = "Span"

                try? self.moc.save()
            }

            Button("Show A") {
                self.lastNameFilter = "A"
            }

            Button("Show S") {
                self.lastNameFilter = "S"
            }
        }
    }
}

struct SingerView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return SingerView().environment(\.managedObjectContext, context)
    }
}
