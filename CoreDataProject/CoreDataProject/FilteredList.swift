//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Ramsey on 2020/6/21.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI
import CoreData

enum PredicateType: String {
    case beginsWith                 =   "BEGINSWITH"
    case contains                   =   "CONTAINS"
    case beginsWithIgnoreCase       = "BEGINSWITH[c]"
    case containsIgnoreCase         = "CONTAINS[c]"
}

struct FilteredList<T: NSManagedObject, Content: View>: View {
    
    var fetchRequest: FetchRequest<T>
    var singers: FetchedResults<T> { fetchRequest.wrappedValue }
    
    let content: (T) -> Content
    
    var body: some View {
        List(singers, id: \.self) { singer in
            self.content(singer)
        }
    }
    
    init(filterKey: String, predicateType: PredicateType, filterValue: String, sortDescriptors: [NSSortDescriptor], @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors, predicate: NSPredicate(format: "%K \(predicateType.rawValue) %@", filterKey, filterValue))
        self.content = content
    }
}

struct FilteredList_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return FilteredList(filterKey: "lastName", predicateType: .beginsWith, filterValue: "", sortDescriptors: []) { (singer: Singer) in
            Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
        }.environment(\.managedObjectContext, context)
    }
}
