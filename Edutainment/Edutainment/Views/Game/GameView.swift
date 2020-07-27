//
//  GameView.swift
//  Edutainment
//
//  Created by Ramsey on 2020/6/6.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var mainState: MainState
    @ObservedObject var game: Game
    @State var userInputAnswer = ""
    @State var animatingIncreaseScore = false
    @State var animatingDecreaseScore = false
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            ZStack {
                HStack {
                    Text("\(game.currentQuestion.text)=")
                        .foregroundColor(.orange)
                    
                    Text("\(userInputAnswer)")
                        .foregroundColor(.purple)
                        
                }
                .font(.system(size: 64))
                .opacity(game.isGameRoundCompleted ? 0.0 : 1.0)
                
                Image(systemName: "hand.thumbsup")
                    .font(.system(size: 32))
                    .foregroundColor(animatingIncreaseScore ? .green : .clear)
                    .opacity(animatingIncreaseScore ? 0 : 1)
                    .offset(x: 0, y: animatingIncreaseScore ? -100 : -75)
                
                Image(systemName: "hand.thumbsdown")
                    .font(.system(size: 32))
                    .foregroundColor(animatingDecreaseScore ? .red : .clear)
                    .opacity(animatingDecreaseScore ? 0 : 1)
                    .offset(x: 0, y: animatingDecreaseScore ? 100 : 75)
                
                GameScoreView(game: game, mainState: mainState)
                    .opacity(game.isGameRoundCompleted ? 1.0 : 0.0)
            }
            
            Spacer()
            
            Keyboard { action in
                self.responseAction(action)
            }
            .frame(height: 250)
        }
        .onAppear(perform: game.generateQuestion)
        .navigationBarItems(
            leading:
                NewGameButton(mainState: mainState),
            trailing:
                Text("Question \(game.selectedCount)/\(game.settings.selectedQuestionNum())")
        )
    }
    
    private func responseAction(_ action: KeyboardButtonActionType) {
        switch action {
        case .submit:
            guard !userInputAnswer.isEmpty else { return }
            handleAnimation(isCorrect: game.userAnswerQuestion(userAnswer: userInputAnswer))
            game.generateQuestion()
            userInputAnswer = ""
            
        case .number(text: let txt):
            userInputAnswer.append(txt)
        case .delete:
            userInputAnswer.removeLast()
        }
    }
    
    private func handleAnimation(isCorrect: Bool) {
        animatingIncreaseScore = false
        animatingDecreaseScore = false
        
        if isCorrect {
            withAnimation(Animation.linear(duration: 1)) {
                animatingIncreaseScore = true
            }
        } else {
            withAnimation(Animation.linear(duration: 1)) {
                animatingDecreaseScore = true
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(mainState: MainState(), game: Game(settings: Settings()))
    }
}
