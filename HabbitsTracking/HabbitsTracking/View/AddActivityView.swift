//
//  AddActivityView.swift
//  HabbitsTracking
//
//  Created by Ramsey on 2020/6/11.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct AddActivityView: View {
    
    @ObservedObject var habit: Habit
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var desc = ""
    
    @State private var issueText = ""
    @State private var shouldShowAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Description", text: $desc)
            }
            .navigationBarTitle("Add Activity")
            .navigationBarItems(trailing:
                Button(action: {
                    guard !self.name.isEmpty else { self.handleIssue(with: "Name can not be empty"); return }
                    guard !self.desc.isEmpty else { self.handleIssue(with: "Description can not be empty"); return }
                    let activityItem = ActivityItem(
                        name: self.name,
                        description: self.desc)
                    self.habit.add(activity: activityItem)
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save")
                })
            )
                .alert(isPresented: $shouldShowAlert) {
                    Alert(title: Text(self.issueText), message: nil, dismissButton: Alert.Button.default(Text("OK")))
            }
        }
    }
    
    private func handleIssue(with text: String) {
        issueText = text
        self.shouldShowAlert.toggle()
    }
}

struct AddActivityView_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityView(habit: Habit()).colorScheme(.dark)
    }
}
