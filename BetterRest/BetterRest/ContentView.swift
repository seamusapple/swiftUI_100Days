//
//  ContentView.swift
//  BetterRest
//
//  Created by Ramsey on 2020/5/30.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let model = SleepCalculate_1()
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    @State private var sleepAmount: Double = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmout: Int = 0
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 24) {
                VStack(spacing: 12.0) {
                    Text("Coffee Cutoff Time")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("\(alertMessage)")
                        .font(.largeTitle)
                        .foregroundColor(.pink)
                }
                .multilineTextAlignment(.center)
                .padding()
                
                Form {
                    Section(header:
                        Text("When do you want to wake up?")
                            .font(.headline)
                    ) {
                        DatePicker("Please enter a date", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                        
                        Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                            Text("\(sleepAmount, specifier: "%g")")
                        }
                    }
                    
                    Section(header:
                        Text("Daily coffee intake")
                        .font(.headline)
                    ) {
                        Picker(selection: $coffeeAmout, label: Text("Coffee intake:")) {
                            ForEach(1..<9) {
                                if $0 == 1 {
                                    Text("\($0) cup")
                                } else {
                                    Text("\($0) cups")
                                }
                            }
                        }
                    }
                }
                
            }
            .navigationBarTitle("BetterRest")
            .navigationBarItems(trailing:
                Button("Calculate") {
                    self.calculateBedtime()
                }
            )
        }
    }
    
    func calculateBedtime() {
        do {
            let prediction = try model.prediction(input: SleepCalculate_1Input(wake: convertDateSecondsFromUserInput(), estimatedSleep: sleepAmount, coffee: Double(coffeeAmout+1)))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            alertMessage = formatter.string(from: sleepTime)
            print(coffeeAmout)
            print(alertMessage)
            alertTitle = "Your ideal bedtime is…"
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
    }
    
    func convertDateSecondsFromUserInput() -> Double {
        let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = dateComponent.hour ?? 0
        let minute = dateComponent.minute ?? 0
        return Double(hour*60*60 + minute*60)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
