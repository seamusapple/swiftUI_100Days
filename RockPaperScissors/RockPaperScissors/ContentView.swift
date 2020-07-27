//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Ramsey on 2020/5/28.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    let actionsArray = ["Rock", "Paper", "Scissors"]
    @State private var currentComputerAction = Int.random(in: 0..<3)
    @State private var shouldWin = Bool.random()
    private var canShoot: Bool { return userChosen != nil }
    @State private var userChosen: String? = nil
    @State private var wholeScore = 0
    @State private var userCorrect = false
    @State private var isShowingGameAlert = false
    let roundLimit: Int = 10
    @State private var currentRound = 1
    var isGameOver: Bool { currentRound == roundLimit }
    
    private var resultAlertTitle: String { userCorrect ? "Correct 👏" : "Sorry" }
    
    private var resultAlertMessage: String {
        let scoreLine = "Your score is now \(wholeScore)."
        
        return "\(scoreLine)"
    }
    
    var body: some View {
        ZStack {
            gradientBackground
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 60) {
                VStack(spacing: 14) {
                    Text("Opponent:")
                        .foregroundColor(.purple)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Image(actionsArray[currentComputerAction])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.purple)
                        .frame(width: 200, height: 200)
                }
                
                VStack (spacing: 20){
                    Text(shouldWin ? "Choose to Win" : "Choose to Lose")
                        .foregroundColor(.purple)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 32) {
                        ForEach(actionsArray, id: \.self) {
                            GameOptionButton(
                                gameItem: $0,
                                opposingGameItem: self.actionsArray[self.currentComputerAction],
                                currentSelection: self.$userChosen)
                        }
                    }
                    
                    shootButton
                }
                
                Spacer()
                
                infoView
            }
        }
        .onAppear {
            self.startNewGame()
        }
    .alert(isPresented: $isShowingGameAlert, content: showAlert)
    }
}

extension ContentView {
    private var gradientBackgroundColors: [Color] {
        switch colorScheme {
        case .dark:
            return [
                Color(white: 0.07),
                Color(white: 0.17),
                Color(white: 0.37),
            ]
        case .light:
            return [.white, Color.purple.opacity(0.4)]
        @unknown default:
            return [.clear, .clear]
        }
    }
}

extension ContentView {
    func showAlert() -> Alert {
        return isGameOver ? replayGameAlert : nextRoundAlert
    }
    
    private var replayGameAlert: Alert {
        Alert(
            title: Text("Game Over"),
            message: Text("You finisehd with \(wholeScore) points."),
            dismissButton: .default(
                Text("Play Again"),
                action: {
                    self.startNewGame()
            }))
    }
    
    private var nextRoundAlert: Alert {
        Alert(
        title: Text(resultAlertTitle),
        message: Text(resultAlertMessage),
        dismissButton: .default(
            Text("Play Again"),
            action: {
                self.nextRound()
        }))
    }
    
    private func startNewGame() {
        currentRound = 1
        wholeScore = 0
        
        configureRound()
        
    }
    
    private func nextRound() {
        currentRound += 1
        
        configureRound()
    }
    
    func configureRound() {
        currentComputerAction = Int.random(in: 0..<3)
        shouldWin = Bool.random()
    }
    
}

extension ContentView {
    private var gradientBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: gradientBackgroundColors),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var shootButton: some View {
        Button(action: {
            guard let chosen = self.userChosen else {
                preconditionFailure("Button should be disabled if nothing is chosen.")
            }
            if self.shouldWin {
                self.userCorrect = self.actionsArray[(self.currentComputerAction+1)%3] == chosen
            } else {
                self.userCorrect = self.actionsArray[(self.currentComputerAction+2)%3] == chosen
            }
            self.wholeScore += self.userCorrect ? 1 : -1
            self.isShowingGameAlert = true
            self.userChosen = nil
        }) {
            Text("Shoot!")
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding()
        .padding(.horizontal)
        .padding(.horizontal)
        .background(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .foregroundColor(.purple)
        .disabled(!canShoot)
        .opacity(canShoot ? 1.0 : 0.3)
        .animation(.easeIn(duration: 0.3))
    }
}

extension ContentView {
    private var infoView: some View {
        HStack {
            Spacer()
            
            Text("Round:")
            Text("\(currentRound)/\(roundLimit)")
                .font(.title)
                .fontWeight(.bold)
            Text("Score:")
            Text("\(wholeScore)")
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
        }
        .foregroundColor(.purple)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct GameOptionButton: View {
    let gameItem: String
    let opposingGameItem: String
    
    @Binding var currentSelection: String?
    
    var isSelected: Bool { gameItem == currentSelection }
    
    var body: some View {
    
        Button(action: {
            guard self.gameItem != self.opposingGameItem else { return }
            
            self.currentSelection = self.gameItem
        }) {
            Image(gameItem)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
        }
        .opacity(isSelected ? 1.0 : 0.3)
        .animation(.easeIn(duration: 0.17))
        .frame(width: 70, height: 70)
    }
}
