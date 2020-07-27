//
//  ContentView.swift
//  Edutainment
//
//  Created by Ramsey on 2020/6/4.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

class MainState: ObservableObject {
    @Published var isShowingSetting = true
}

struct MainView: View {
    @ObservedObject var mainState = MainState()
    @ObservedObject var settings = Settings()
    
    var body: some View {
        NavigationView {
            Group {
                if mainState.isShowingSetting {
                    SettingsView(settings: settings, mainState: mainState)
                } else {
                    GameView(mainState: mainState, game: Game(settings: settings))
                }
            }
        .navigationBarTitle("Multiplication")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().colorScheme(.dark)
    }
}
