//
//  User+CoreDataProperties.swift
//  FriendFace
//
//  Created by Ramsey on 2020/6/21.
//  Copyright © 2020 Ramsey. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var email: String?
    @NSManaged public var address: String?
    @NSManaged public var about: String?
    @NSManaged public var registered: String?
    @NSManaged public var tags: [NSObject]?
    @NSManaged public var company: Company?
    @NSManaged public var friends: NSSet?

    public var uId: String {
        id ?? "\(UUID())"
    }
    
    public var uName: String {
        name ?? "Unknown name"
    }

    public var uEmail: String {
        email ?? "Unknown email"
    }

    public var uAddress: String {
        address ?? "Unknown address"
    }

    public var uDescription: String {
        about ?? "Unknown description"
    }
    
    public var uRegisteredTime: String {
        registered ?? "Unknown register time"
    }
    
    public var uCompanyName: String {
        company?.cName ?? "Unkown company"
    }
    
    public var friendsArray: [User] {
        let set = friends as? Set<User> ?? []
        return set.sorted {
            $0.uName < $1.uName
        }
    }
    
    public var tagsArray: [String] {
        let array = tags as? [String] ?? []
        return array
    }
}

// MARK: Generated accessors for friends
extension User {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: User)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: User)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}
