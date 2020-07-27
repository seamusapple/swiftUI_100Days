//
//  ContentView.swift
//  iExpense
//
//  Created by Ramsey on 2020/6/6.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var expenses = Expense()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) {  item in
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                                .font(.body)
                        }
                        Spacer()
                        Text("$\(item.amount)")
                            .foregroundColor(self.getColorForItem(amount: item.amount))
                    }
                }
                .onDelete(perform: self.deleteItem)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(
                leading: EditButton(),
                trailing:
                    Button(action: {
                        self.showingAddExpense.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    }
                )
            )
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: self.expenses)
        }
    }
    
    func getColorForItem(amount: Int) -> Color {
        if amount <= 10 { return Color.green }
        if amount <= 100 { return Color.orange }
        return Color.red
    }
    
    func deleteItem(at offsets: IndexSet) {
        self.expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().colorScheme(.dark)
    }
}
