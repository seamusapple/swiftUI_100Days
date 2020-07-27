//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Ramsey on 2020/7/2.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
    public var wrappedTitle: String {
        get {
            self.title ?? "Unknown value"
        }

        set {
            title = newValue
        }
    }

    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? "Unknown value"
        }

        set {
            subtitle = newValue
        }
    }
}
