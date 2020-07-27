//
//  OrderStruct.swift
//  CupcakeCorner
//
//  Created by Ramsey on 2020/6/16.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

class ObservableOrder: ObservableObject {
    @Published var order: OrderStruct!
    
    init(order: OrderStruct) {
        self.order = order
    }
}
struct OrderStruct: Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        if name.isEmpty
            || streetAddress.isEmpty
            || city.isEmpty
            || zip.isEmpty {
            return false
        }
        
        if name.isAllSpaces
            || streetAddress.isAllSpaces
            || city.isAllSpaces
            || zip.isAllSpaces {
            return false
        }
        return true
    }
    
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2

        // complicated cakes cost more
        cost += (Double(type) / 2)

        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }

        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }

        return cost
    }
}
