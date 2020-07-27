//
//  Expense.swift
//  iExpense
//
//  Created by Ramsey on 2020/6/6.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expense: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        guard let itemsData = UserDefaults.standard.object(forKey: "Items") as? Data else { self.items = []; return }
        let decoder = JSONDecoder()
        guard let items = try? decoder.decode([ExpenseItem].self, from: itemsData) else { self.items = []; return }
        self.items = items
    }
}
