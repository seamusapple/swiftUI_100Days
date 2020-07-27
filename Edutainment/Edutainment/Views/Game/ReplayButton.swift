//
//  ReplayButton.swift
//  Edutainment
//
//  Created by Ramsey on 2020/6/6.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct ReplayButton: View {
    @ObservedObject var game: Game
    
    var body: some View {
        Button(action: {
            self.game.replayGame()
        }) {
            Text("Replay game")
                .foregroundColor(.green)
        }
    }
}

struct ReplayButton_Previews: PreviewProvider {
    static var previews: some View {
        ReplayButton(game: Game(settings: Settings()))
    }
}
