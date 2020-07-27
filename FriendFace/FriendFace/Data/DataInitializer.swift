//
//  DataInitializer.swift
//  FriendFace
//
//  Created by Ramsey on 2020/6/21.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import CoreData

struct DataInitializer {
    
    var id: String
    var name: String
    var isActive: Bool
    var age: Int
    var email: String
    var company: String
    var address: String
    var about: String
    var registered: String
    var tags: [String]
    var friends: [JSONFriend]
    
    static func loadData(moc: NSManagedObjectContext) {
        DispatchQueue.global().async {
            fetchData { users in
                DispatchQueue.main.async {
                    var coreUsers: [User] = []
                    for user in users {
                        let coreUser = User(context: moc)
                        coreUser.id = user.id
                        coreUser.name = user.name
                        coreUser.isActive = user.isActive
                        coreUser.address = user.address
                        coreUser.about = user.about
                        coreUser.age = Int16(user.age)
                        coreUser.email = user.email
                        coreUser.registered = user.registered
                        coreUser.tags = user.tags as [NSObject]
                        
                        let company = Company(context: moc)
                        company.name = user.company
                        coreUser.company = company
                        
                        coreUsers.append(coreUser)
                    }
                    
                    for i in 0..<users.count {
                        for friend in users[i].friends {
                            if let newFriend = coreUsers.first(where: { $0.id == friend.id }) {
                                coreUsers[i].addToFriends(newFriend)
                            }
                        }
                    }
                    
                    do {
                        try moc.save()
                    }
                    catch let saveError {
                        print("Could not save data: \(saveError.localizedDescription)")
                    }
                }
            }
        }
    }
    
    static func fetchData(completion: @escaping ([JSONUser]) -> Void) {
        print("Fetching Data")
        
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode([JSONUser].self, from: data)
                completion(decoded)
            }
            catch let decodingError {
                print("Decoding failed: \(decodingError.localizedDescription)")
            }
        }
        session.resume()
    }
}
