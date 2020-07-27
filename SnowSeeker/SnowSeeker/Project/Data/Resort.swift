//
//  Resort.swift
//  SnowSeeker
//
//  Created by Ramsey on 2020/7/19.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import Foundation

struct Resort: Identifiable, Codable {
    let id: String
    let name: String
    let country: String
    let description: String
    let imageCredit: String
    let price: Int
    let size: Int
    let snowDepth: Int
    let elevation: Int
    let runs: Int
    let facilities: [String]
    
    var facilityTypes: [Facility] {
        facilities.map(Facility.init)
    }
    
    static let allResorts: [Resort] = Bundle.main.decode("resorts.json")
    static let example = allResorts[0]
}

extension Resort {
    var sizeText: String {
        Self.sizeText(from: size)
    }

    static func sizeText(from size: Int) -> String {
        switch size {
        case 1:
            return "Small"
        case 2:
            return "Average"
        default:
            return "Large"
        }
    }

    static func size(from sizeText: String) -> Int {
        switch sizeText {
        case "Small":
            return 1
        case "Average":
            return 2
        default:
            return 3
        }

    }

    var priceText: String {
        Self.priceText(from: price)
    }

    static func priceText(from price: Int) -> String {
        String(repeating: "$", count: price)
    }

    static func price(from priceText: String) -> Int {
        return priceText.count
    }
}
