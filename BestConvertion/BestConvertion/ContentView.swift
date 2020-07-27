//
//  ContentView.swift
//  BestConvertion
//
//  Created by Ramsey on 2020/5/26.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var inputTime = ""
    @State private var selectedInputUnit = 0
    @State private var selectedOutputUnit = 1
    
    let timeUnit = ["second", "minute", "hour", "day"]
    let timeConvertion: [Double] = [1, 60, 60*60, 60*60*24]
    private var outputTime: Double {
        let input = Double(inputTime) ?? 0
        let inputSecond = input * timeConvertion[selectedInputUnit]
        let output = inputSecond / timeConvertion[selectedOutputUnit]
        return output
    }
    
    var body: some View {
        Form {
            Section {
                Picker("Choose input unit", selection: $selectedInputUnit) {
                    ForEach(0..<timeUnit.count) {
                        Text("\(self.timeUnit[$0])")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                TextField("Input time", text: $inputTime)
                    .frame(height: 40)
                    .keyboardType(.numberPad)
                
                Picker("Choose output unit", selection: $selectedOutputUnit) {
                    ForEach(0..<timeUnit.count) {
                        Text("\(self.timeUnit[$0])")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Text("Output time: \(outputTime, specifier: "%g")")
            }
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
