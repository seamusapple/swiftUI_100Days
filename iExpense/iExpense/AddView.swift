//
//  AddView.swift
//  iExpense
//
//  Created by Ramsey on 2020/6/6.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct AddView: View {
    
    @ObservedObject var expenses: Expense
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    
    @State private var issueText = ""
    @State private var shouldShowAlert = false
    static let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(
                trailing:
                Button(action: {
                    guard !self.name.isEmpty else { self.handleIssue(with: "Name can not be empty"); return }
                    guard !self.amount.isEmpty else { self.handleIssue(with: "Amount can not be empty"); return }
                    guard let actualAmount = Int(self.amount) else { self.handleIssue(with: "Invalid amount") ;return }
                    let expenseItem = ExpenseItem(
                        name: self.name,
                        type: self.type,
                        amount: actualAmount)
                    self.expenses.items.append(expenseItem)
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save")
                })
            )
            .alert(isPresented: $shouldShowAlert) {
                Alert(title: Text(self.issueText), message: nil, dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func handleIssue(with text: String) {
        issueText = text
        self.shouldShowAlert.toggle()
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expense())
    }
}
