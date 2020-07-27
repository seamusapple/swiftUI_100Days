//
//  ContentView.swift
//  WeSplit
//
//  Created by Ramsey on 2020/5/26.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var checkAmount = ""
    @State private var numberOfPeople = ""
    @State private var tipPercentage = 2
    
    let tipPercentages = [10, 15, 20, 25, 0]
    var totalAmount: Double {
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        return grandTotal
    }
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople) ?? 2
        let amountPerPerson = totalAmount / peopleCount
        return amountPerPerson
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                        .frame(height: 50)
                        .font(.headline)
                    
//                    Picker("Number of people", selection: $numberOfPeople) {
//                        ForEach(2..<101) {
//                            Text("\($0) people")
//                        }
//                    }
                    TextField("Number of people", text: $numberOfPeople)
                        .keyboardType(.decimalPad)
                        .frame(height: 50)
                        .font(.headline)
                }
                
                Section(header: Text("How much tip do you want to leave?")) {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0..<tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(height: 50)
                    .font(.headline)
                }
                
                Section(header: Text("Total Amount")) {
                    Text("$\(totalAmount, specifier: "%g")")
                        .frame(height: 50)
                        .font(.headline)
                }
                
                Section(header: Text("Amount per person")) {
                    Text("$\(totalPerPerson, specifier: "%g")")
                        .frame(height: 50)
                        .font(.headline)
                        .foregroundColor(tipPercentage == tipPercentages.count-1 ? .red : .black)
                }
            }
        .navigationBarTitle("WeSplit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
