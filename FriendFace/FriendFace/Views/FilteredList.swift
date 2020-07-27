//
//  FilteredList.swift
//  FriendFace
//
//  Created by Ramsey on 2020/6/21.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI
import CoreData

enum PredicateType: String {
    case beginsWith                 =   "BEGINSWITH"
    case contains                   =   "CONTAINS"
    case beginsWithIgnoreCase       =   "BEGINSWITH[c]"
    case containsIgnoreCase         =   "CONTAINS[c]"
    case noFilter                   =   "NONE"
}

struct FilteredList<T: NSManagedObject, Content: View>: View {
    
    var fetchRequest: FetchRequest<T>
    var users: FetchedResults<T> { fetchRequest.wrappedValue }
    var moc: NSManagedObjectContext
    
    let content: (T) -> Content
    
    var body: some View {
        List(users, id: \.self) { user in
            self.content(user)
        }
        .onAppear(perform: checkDataLoad)
    }
    
    init(in moc:NSManagedObjectContext, filterKey: String, predicateType: PredicateType, filterValue: String, sortDescriptors: [NSSortDescriptor], @ViewBuilder content: @escaping (T) -> Content) {
        if predicateType == .noFilter {
            fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors)
        } else {
            fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors, predicate: NSPredicate(format: "%K \(predicateType.rawValue) %@", filterKey, filterValue))
        }
        self.content = content
        self.moc = moc
    }
    
    func checkDataLoad() {
        if users.isEmpty {
            DataInitializer.loadData(moc: self.moc)
        }
    }
}

struct FilteredList_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return FilteredList(in: context, filterKey: "name", predicateType: .beginsWith, filterValue: "", sortDescriptors: []) { (user: User) in
            Text("\(user.uName) \(user.uId)")
        }.environment(\.managedObjectContext, context)
    }
}
