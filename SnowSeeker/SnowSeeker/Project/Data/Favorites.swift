//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Ramsey on 2020/7/19.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

class Favorites: ObservableObject {
    // the actual resorts the user has favorited
    private var resorts: Set<String>

    // the key we're using to read/write in UserDefaults
    private let saveKey = "Favorites"

    init() {
        // load our saved data
        guard let data = UserDefaults.standard.object(forKey: saveKey) as? Data else { self.resorts = []; return }
        do {
            let decoded = try JSONDecoder().decode(Set<String>.self, from: data)
            self.resorts = decoded
            return
        } catch {
            print("Encoded data failed.")
        }
        // still here? Use an empty array
        self.resorts = []
    }

    // returns true if our set contains this resort
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }

    // adds the resort to our set, updates all views, and saves the change
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }

    // removes the resort from our set, updates all views, and saves the change
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }

    func save() {
        // write out our data
        do {
            let encoded = try JSONEncoder().encode(resorts)
            UserDefaults.standard.set(encoded, forKey: saveKey)
        } catch {
            print("Encoded data failed.")
        }
    }
}
