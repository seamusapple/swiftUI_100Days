//
//  AddBookView.swift
//  Bookworm
//
//  Created by Ramsey on 2020/6/16.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct AddBookView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    @State private var showingAlert = false
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)

                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section {
                    Section {
                        RatingView(rating: $rating)
                        TextField("Write a review", text: $review)
                    }
                }

                Section {
                    Button("Save") {
                        guard !self.genre.isEmpty else { self.showingAlert = true; return  }
                        let newBook = Book(context: self.moc)
                        
                        newBook.title = self.title
                        newBook.author = self.author
                        newBook.rating = Int16(self.rating)
                        newBook.genre = self.genre
                        newBook.review = self.review
                        newBook.date = Date()
                        
                        try? self.moc.save()
                        
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text("Please choose a genre for the book"), message: nil, dismissButton: .default(Text("OK")))
            })
            .navigationBarTitle("Add Book")
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
