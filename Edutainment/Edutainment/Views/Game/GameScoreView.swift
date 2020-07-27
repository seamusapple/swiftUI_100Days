//
//  GameScoreView.swift
//  Edutainment
//
//  Created by Ramsey on 2020/6/6.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct GameScoreView: View {
    @ObservedObject var game: Game
    @ObservedObject var mainState: MainState
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                Text("Score ")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                    .fontWeight(.semibold)
                Text("\(game.correctAnswerCount)/\(game.settings.selectedQuestionNum())")
                    .font(.system(size: 60))
                    .foregroundColor(.purple)
                    .fontWeight(.semibold)
            }
            
            HStack(alignment: .center, spacing: 30) {
                NewGameButton(mainState: mainState)
                
                ReplayButton(game: game)
            }
            .font(.system(size: 30))
        }
    }
}

struct GameScoreView_Previews: PreviewProvider {
    static var previews: some View {
        GameScoreView(game: Game(settings: Settings()), mainState: MainState())
    }
}
