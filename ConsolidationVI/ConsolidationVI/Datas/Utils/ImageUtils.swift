//
//  ImageUtils.swift
//  ConsolidationVI
//
//  Created by Ramsey on 2020/7/8.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import UIKit

struct ImageUtils {
    static func saveImage(_ imageData: Data) -> String? {
        let url = getDocumentDirectory().appendingPathComponent(UUID().uuidString)
        do {
            try imageData.write(to: url, options: [.atomic, .completeFileProtection])
            return url.lastPathComponent
        } catch let error {
            print("Could not write image: " + error.localizedDescription)
        }
        return nil
    }
    
    static func updateImage(_ imageData: Data, urlPath: String?) {
        guard let imagePath = urlPath else { return }
        let url = getDocumentDirectory().appendingPathComponent(imagePath)
        do {
            try imageData.write(to: url, options: [.atomic, .completeFileProtection])
        } catch let error {
            print("Could not write image: " + error.localizedDescription)
        }
    }
    
    static func getImage(_ urlPath: String?) -> UIImage? {
        guard let imagePath = urlPath else { return nil }
        let url = getDocumentDirectory().appendingPathComponent(imagePath)
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }
    
    static func deleteImage(_ urlPath: String?) {
        guard let imagePath = urlPath else { return }
        let url = getDocumentDirectory().appendingPathComponent(imagePath)
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch let error {
            print("Could not delete image: " + error.localizedDescription)
        }
    }
    
    private static func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
