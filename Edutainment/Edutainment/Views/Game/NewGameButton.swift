//
//  NewGameButton.swift
//  Edutainment
//
//  Created by Ramsey on 2020/6/6.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct NewGameButton: View {
    var mainState: MainState
    
    var body: some View {
        Button(action: {
            self.mainState.isShowingSetting.toggle()
        }) {
            Text(self.mainState.isShowingSetting ? "" : "New game")
                .foregroundColor(.blue)
        }
    }
}

struct NewGameButton_Previews: PreviewProvider {
    static var previews: some View {
        NewGameButton(mainState: MainState())
    }
}
