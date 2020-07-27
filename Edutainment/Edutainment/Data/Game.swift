//
//  Game.swift
//  Edutainment
//
//  Created by Ramsey on 2020/6/6.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct Question: Hashable {
    var text: String
    var answer: String
}

class Game: ObservableObject {
    @ObservedObject var settings: Settings
    @Published var currentQuestion = Question(text: "", answer: "")
    @Published var selectedCount = 0
    @Published var isGameRoundCompleted = false
    
    var correctAnswerCount = 0
    
    var questions = [Question]()
    init(settings: Settings) {
        self.settings = settings
        
        self.constructQuestioons()
    }
    
    private func constructQuestioons() {
        questions.removeAll()
        selectedCount = 0
        correctAnswerCount = 0
        
        let tableUpTo = settings.tablesUpTo
        let maxTimeCount = settings.maxTimesCount
        for i in 1...maxTimeCount {
            for j in 1...tableUpTo {
                let question = Question(text: "\(i) x \(j)", answer: "\(i*j)")
                let questionReversed = Question(text: "\(j) x \(i)", answer: "\(i*j)")
                questions.append(question)
                questions.append(questionReversed)
            }
        }
        questions = Array(Set(questions))
        questions.shuffle()
    }
    
    func replayGame() {
        selectedCount = 0
        correctAnswerCount = 0
        questions.shuffle()
        generateQuestion()
        isGameRoundCompleted = false
    }
    
    func generateQuestion() {
        if "\(selectedCount)" == settings.selectedQuestionNum() {
            isGameRoundCompleted = true
            return
        }
        currentQuestion = questions[selectedCount]
        selectedCount += 1
    }
    
    func userAnswerQuestion(userAnswer: String) -> Bool {
        if currentQuestion.answer == userAnswer {
            correctAnswerCount += 1
            return true
        }
        return false
    }
}
