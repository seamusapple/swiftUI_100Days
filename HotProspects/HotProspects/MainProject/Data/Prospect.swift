//
//  Prospect.swift
//  HotProspects
//
//  Created by Ramsey on 2020/7/10.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    let id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var date = Date()
    fileprivate(set) var isContacted = false
}

class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    static let saveKey = "SavedData"
    
    init(inDirectory: Bool = false) {
        if inDirectory {
            let url = Self.getDocumentDirectory().appendingPathComponent(Self.saveKey)
            if let data = try? Data(contentsOf: url) {
                if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                    self.people = decoded
                    return
                }
            }
        } else {
            if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
                if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                    self.people = decoded
                    return
                }
            }
        }

        self.people = []
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        prospect.date = Date()
        save(inDirectory: true)
    }
    
    private func save(inDirectory: Bool = false) {
        if inDirectory {
            let url = Self.getDocumentDirectory().appendingPathComponent(Self.saveKey)
            do {
                if let encoded = try? JSONEncoder().encode(people) {
                    try encoded.write(to: url, options: [.atomic, .completeFileProtection])
                }
            } catch let error {
                print("Could not write image: " + error.localizedDescription)
            }
        } else {
            if let encoded = try? JSONEncoder().encode(people) {
                UserDefaults.standard.set(encoded, forKey: Self.saveKey)
            }
        }
    }
    
    static private func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save(inDirectory: true)
    }
}
