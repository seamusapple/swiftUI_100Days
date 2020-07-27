//
//  DetailView.swift
//  ConsolidationVI
//
//  Created by Ramsey on 2020/7/8.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI
import MapKit

struct DetailView: View {
    var contact: Contact
    
    @State private var pickerTab = 0
    
    var body: some View {
        VStack {
            Picker("", selection: $pickerTab) {
                Text("Photo").tag(0)
                Text("Event location").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if pickerTab == 0 {
                contact.getAvatar()
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.gray)
                    .tag("Photo")
            } else {
                if contact.locationRecorded {
                    MapView(annotation: getAnnotation())
                }
                else {
                    Text("Location was not recorded for this contact")
                        .padding()
                }
            }

            Spacer()
        }
        .navigationBarTitle(Text(contact.name), displayMode: .inline)
    }
    
    func getAnnotation() -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: contact.latitude, longitude: contact.longitude)
        return annotation
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(contact: Contact.example)
    }
}
