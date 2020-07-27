//
//  AddContactView.swift
//  ConsolidationVI
//
//  Created by Ramsey on 2020/7/6.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct AddContactView: View {
    @ObservedObject var addressBook: AddressBook
    @Environment(\.presentationMode) var presentationMode
    @State private var contactName = ""
    @State private var errorMessage = ""
    @State private var showingErrorMessage = false
    @State private var image: Image?
    @State private var uiImage: UIImage?
    @State private var showingImagePicker = false
    @State private var imageSourceType: ImageSourceType = .library
    private let locationFetcher = LocationFetcher()
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Photo")) {
                    if image == nil {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray, style: StrokeStyle(lineWidth: 1, lineCap: CGLineCap.round, dash: [5, 5]))
                            .scaledToFit()
                    } else {
                        image?
                            .resizable()
                            .scaledToFit()
                    }
                    HStack {
                        Text("Take new...")
                            .onTapGesture(perform: takePicture)

                        Spacer()

                        Text("Select existing...")
                            .onTapGesture(perform: selectPhoto)
                    }
                }
                
                Section(header: Text("Name")) {
                    TextField("Provide contact name", text: $contactName)
                }
            }
            .navigationBarTitle("Add contact")
            .navigationBarItems(
                trailing:
                    Button(action: { self.saveContact() },
                           label: { Text("Add") }
                )
            )
        }
        .padding(.bottom, keyboard.currentHeight)
        .alert(isPresented: $showingErrorMessage) {
            return Alert(title: Text("Add contact failed"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage, content: {
            ImagePicker(image: self.$uiImage, sourceType: self.imageSourceType)
        })
    }
    
    func takePicture() {
        if ImagePicker.isCameraAvailable() {
            self.imageSourceType = .camera
            self.showingImagePicker = true
        }
        else {
            self.errorMessage = "Camera is not available"
            self.showingErrorMessage = true
        }
    }

    func selectPhoto() {
        self.imageSourceType = .library
        self.showingImagePicker = true
    }
    
    private func loadImage() {
        if let uiImage = uiImage {
            image = Image(uiImage: uiImage)
        }
    }
    
    private func saveContact() {
        guard !contactName.isEmpty else {
            errorMessage = "Please provide contact name"
            showingErrorMessage = true
            return
        }
        guard image != nil && uiImage != nil else {
            errorMessage = "Please import contact avatar"
            showingErrorMessage = true
            return
        }
        var newContact = Contact(name: contactName)
        newContact.setAvatar(image: uiImage!)
        self.addressBook.add(newContact)
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AddContactView_Previews: PreviewProvider {
    static var previews: some View {
        AddContactView(addressBook: AddressBook())
    }
}
