//
//  MainView.swift
//  Flashzilla
//
//  Created by Ramsey on 2020/7/11.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI
import CoreHaptics

struct MainView: View {
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    
    @State private var cards = [Card]()
    @State private var timeRemaining = 100
    @State private var isActive = true
    @State private var showingEditScreen = false
    @State private var showingSettingScreen = false
    @State private var engine: CHHapticEngine?
    
    @State private var allowRestackForWrongAnswer = false
    @State private var initialCardsCount = 0
    @State private var correctCards = 0
    @State private var incorrectCards = 0
    private var reviewedCards: Int {
        correctCards + incorrectCards
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(Color.black)
                            .opacity(0.75)
                    )
                    
                ZStack {
                    ForEach(cards) { card in
                        CardView(card: card, allowRestackForWrongAnswer: self.allowRestackForWrongAnswer) { isCorrect in

                            if isCorrect {
                                self.correctCards += 1
                            }
                            else {
                                self.incorrectCards += 1

                                if self.allowRestackForWrongAnswer {
                                    self.restackCard(at: self.index(for: card))
                                    return
                                }
                            }

                            // remove card
                            withAnimation {
                                self.removeCard(at: self.index(for: card))
                            }
                        }
                        .stacked(at: self.index(for: card), in: self.cards.count)
                        .allowsHitTesting(self.index(for: card) == self.cards.count - 1)
                        .accessibility(hidden: self.index(for: card) < self.cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if timeRemaining == 0 || !isActive {
                    RestartView(allowRestackForWrongAnswer: allowRestackForWrongAnswer,
                                initialCardsCount: initialCardsCount,
                                reviewedCards: reviewedCards,
                                correctCards: correctCards,
                                incorrectCards: incorrectCards,
                                restartAction: resetCards)
                    // in comparison with the 450, 250 for each card
                    .frame(width: 300, height: 200)
                }
            }
            
            VStack {
                HStack {
                    Spacer()

                    Image(systemName: "plus.circle")
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .clipShape(Circle())
                        .onTapGesture {
                            self.showingEditScreen = true
                    }
                    .sheet(isPresented: $showingEditScreen, onDismiss: resetCards) {
                        EditCards()
                    }
                }

                Spacer()
                
                HStack {
                    Spacer()

                    Image(systemName: "gear")
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .clipShape(Circle())
                        .onTapGesture {
                            self.showingSettingScreen = true
                    }
                    .sheet(isPresented: $showingSettingScreen, onDismiss: resetCards) {
                        SettingView(allowRestackForWrongAnswer: self.$allowRestackForWrongAnswer)
                    }
                }
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
//            if differentiateWithoutColor || accessibilityEnabled { // This becomes true when tapped
            if differentiateWithoutColor {
                VStack {
                    Spacer()

                    HStack {
                        Button(action: {
                            withAnimation {
                                self.incorrectCards += 1

                                if self.allowRestackForWrongAnswer {
                                    self.restackCard(at: self.cards.count - 1)
                                    return
                                }
                            }
                        }) {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Wrong"))
                        .accessibility(hint: Text("Mark your answer as being incorrect."))
                        Spacer()

                        Button(action: {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1)
                                self.correctCards += 1
                            }
                        }) {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Correct"))
                        .accessibility(hint: Text("Mark your answer as being correct."))
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard self.isActive else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.reactTimeOutWithHaptic()
                self.isActive = false
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            self.isActive = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            if self.cards.isEmpty == false {
                self.isActive = true
            }
        }
        .onAppear(perform: resetCards)
    }
    
    func index(for card: Card) -> Int {
        return cards.firstIndex(where: { $0.id == card.id }) ?? 0
    }
    
    func restackCard(at index: Int) {
        guard index >= 0 else { return }

        let card = cards[index]
        cards.remove(at: index)
        cards.insert(card, at: 0)
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        cards.remove(at: index)
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
                
                self.initialCardsCount = cards.count
                self.correctCards = 0
                self.incorrectCards = 0
            }
        }
    }
    
    func reactTimeOutWithHaptic() {
        var events = [CHHapticEvent]()
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0, height: offset * 10))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
