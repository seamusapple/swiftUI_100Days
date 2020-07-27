//
//  Response.swift
//  CupcakeCorner
//
//  Created by Ramsey on 2020/6/15.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}
