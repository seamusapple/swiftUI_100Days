//
//  SettingsView.swift
//  Edutainment
//
//  Created by Ramsey on 2020/6/6.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: Settings
    @ObservedObject var mainState: MainState
    
    var body: some View {
        VStack {
            Form {
                Section(header:
                    Text("Tables up to...")
                        .font(.title)
                        .foregroundColor(.orange)) {
                            Stepper(value: $settings.tablesUpTo, in: 1...settings.maxTimesCount) {
                                Text("\(settings.tablesUpTo)")
                            }
                }
                
                Section(header:
                    Text("Number of questions")
                        .font(.title)
                        .foregroundColor(.purple)) {
                            
                    Picker("Number of questions",
                           selection: $settings.numberOfQuestionSelectionCase)
                        {
                            ForEach(settings.numbersOfQuestions, id: \.self) { number in
                                Text(self.allQuestionNumbers(for: number))
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .font(.largeTitle)
                }
            }
            
            Button("Start") {
                self.mainState.isShowingSetting.toggle()
            }
            .font(.system(size: 64))
        }
        .navigationBarItems(
            leading:
                    Spacer(),
            trailing:
                Text("")
        )
    }
    
    private func allQuestionNumbers(for numberOfQuestion: NumberOfQuestions) -> String {
        guard numberOfQuestion == .all else { return numberOfQuestion.rawValue }
        return "All(\(settings.allQuestionNumber()))"
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settings: Settings(), mainState: MainState())
    }
}
