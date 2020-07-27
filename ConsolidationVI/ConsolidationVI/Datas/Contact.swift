//
//  Contact.swift
//  ConsolidationVI
//
//  Created by Ramsey on 2020/7/6.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct Contact: Codable, Identifiable, Comparable, Equatable {
    static let example: Contact = Contact(name: "Ramsey")
    
    var id = UUID()
    let name: String
    var avatarUrl: String? = nil
    
    var locationRecorded = false

    /// Valid only if locationRecorded is true
    var latitude: Double = 0

    /// Valid only if locationRecorded is true
    var longitude: Double = 0
    
    mutating func setAvatar(image: UIImage) {
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            let urlPath = ImageUtils.saveImage(jpegData)
            avatarUrl = urlPath
        }
    }
    
    mutating func updateAvatar(image: UIImage) {
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            ImageUtils.updateImage(jpegData, urlPath: avatarUrl)
        }
    }
    
    mutating func deleteImage() {
        ImageUtils.deleteImage(avatarUrl)
        avatarUrl = nil
    }
    
    func getAvatar() -> Image {
        if let uiImage = ImageUtils.getImage(avatarUrl) {
            return Image(uiImage: uiImage)
        }
        return Image(systemName: "person.crop.square")
    }
    
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.name < rhs.name
    }
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.id == rhs.id
    }
}

class AddressBook: ObservableObject {
    private static let addressBookKey = "addressBook"
    
    @Published var contacts: [Contact] = [] {
        didSet {
            saveData()
        }
    }
    
    init() {
        loadData()
    }
    
    func add(_ contact: Contact) {
        contacts.append(contact)
        contacts.sort()
    }
    
    func remove(atOffsets offsets: IndexSet) {
        for index in offsets {
            var contact = contacts[index]
            contact.deleteImage()
            contacts.remove(at: index)
        }
    }
    
    func update(_ contact: Contact, with newContact: Contact) {
        if let index = contacts.firstIndex(where: { $0 == contact }) {
            contacts.remove(at: index)
            add(newContact)
        } else {
            print("Contact not found")
        }
    }
    
    private func loadData() {
        if let encoded = UserDefaults.standard.data(forKey: Self.addressBookKey) {
            do {
                let decoded = try JSONDecoder().decode([Contact].self, from: encoded)
                self.contacts = decoded.sorted()
            }
            catch let error {
                print("Could not decode: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveData() {
        do {
            let encoded = try JSONEncoder().encode(contacts.self)
            UserDefaults.standard.set(encoded, forKey: Self.addressBookKey)
        } catch let error {
            print("Could not encode: \(error.localizedDescription)")
        }
    }
}
