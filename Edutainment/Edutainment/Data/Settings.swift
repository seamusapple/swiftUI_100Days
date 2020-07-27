//
//  Settings.swift
//  Edutainment
//
//  Created by Ramsey on 2020/6/6.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI
enum NumberOfQuestions: String, CaseIterable {
    case five   = "5"
    case ten    = "10"
    case twenty = "20"
    case all    = "All(80)"
}

class Settings: ObservableObject {
    @Published var tablesUpTo = 1
    @Published var numberOfQuestionSelectionCase = NumberOfQuestions.five
    
    var maxTimesCount = 12
    var numbersOfQuestions = NumberOfQuestions.allCases
    
    func allQuestionNumber() -> Int {
        return maxTimesCount * tablesUpTo * 2 - tablesUpTo * tablesUpTo
    }
    
    func selectedQuestionNum() -> String {
        switch numberOfQuestionSelectionCase {
        case .five: return "5"
        case .ten: return "10"
        case .twenty: return "20"
        case .all: return "\(allQuestionNumber())"
        }
    }
}
