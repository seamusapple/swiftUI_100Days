//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Ramsey on 2020/5/27.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var wholeScore = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var isCorrect = false
    @State private var flagRotations: [Double] = [
        0.0,
        0.0,
        0.0,
    ]
    
    @State private var flagOpacities: [Double] = [
        1.0,
        1.0,
        1.0,
    ]
    @State private var backGroundColors = [Color.blue, .black]
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: self.backGroundColors), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(spacing: 30) {
                    Text("Tap the flag of")
                        .ProminentTitleStyle()
                    
                    
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black) 
                        .frame(width: 300)
                }
                
                VStack(spacing: 30) {
                    ForEach(0..<3) { number in
                        Button(action: {
                            self.flagTapped(number)
                        }) {
                            FlagImage(imageName: self.countries[number])
                                .accessibility(label: Text(self.labels[self.countries[number], default: "Unknown flag"]))
                        }
                        .rotation3DEffect(
                            .radians(self.flagRotations[number]),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .opacity(self.flagOpacities[number])
                    }
                
                    Text("Current score: \(wholeScore)")
                        .font(.title)
                        .fontWeight(.black)
                }
                
                GridStack(rows: 4, columns: 4) { row, col in
                    HStack {
                        Image(systemName: "\(row * 4 + col).circle")
                        Text("R\(row) C\(col)")
                    }
                }
                
                Spacer()
            }

            .alert(isPresented: $showingScore) { () -> Alert in
                Alert(title: Text(scoreTitle), message: Text("Your score is \(wholeScore)"), dismissButton: .default(Text("Continue")) {
                    self.performVictorySpin()
                })
            }
        }
    }
    
    func performVictorySpin() {
        let spinDuration = 0.4
        let spinAnimation = Animation.easeInOut(duration: spinDuration)
        
        withAnimation(spinAnimation) {
            self.flagRotations[correctAnswer] += 2 * .pi
            
            if isCorrect {
                for index in 0..<3 {
                    if correctAnswer != index {
                        self.flagOpacities[index] = 0.2
                    } else {
                        self.flagOpacities[index] = 1.0
                    }
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + (spinDuration + 0.6)) {
            self.askQuestion()
            self.resetFlagAppearances()
        }
    }
    
    func resetFlagAppearances() {
        flagOpacities = [1.0, 1.0, 1.0]
        backGroundColors = [Color.blue, .black]
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            wholeScore += 1
            isCorrect = true
        } else {
            scoreTitle = "Wrong! That’s the flag of \(countries[number])"
            wholeScore -= 1
            isCorrect = false
            backGroundColors = [Color.green, Color.purple]
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
