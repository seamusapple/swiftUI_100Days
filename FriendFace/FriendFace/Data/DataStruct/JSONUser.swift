//
//  JSONUser.swift
//  FriendFace
//
//  Created by Ramsey on 2020/6/21.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import Foundation

struct JSONUser: Codable, Identifiable {
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
}
