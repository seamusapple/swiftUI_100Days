//
//  ContentView.swift
//  WordScramble
//
//  Created by Ramsey on 2020/6/2.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word",
                          text: $newWord,
                          onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                    
                // Project 18 - Challenge 2
                GeometryReader { listGeo in
                    List(self.usedWords, id:\.self) { word in
                        GeometryReader { itemGeo in
                            HStack {
                                Image(systemName: "\(word.count).circle")
                                    // Project 18 - Challenge 3
                                    .foregroundColor(self.getColor(listGeo: listGeo, itemGeo: itemGeo))
                                Text(word)
                            }
                            .frame(width: itemGeo.size.width, alignment: .leading)
                            .offset(x: self.getOffset(listGeo: listGeo, itemGeo: itemGeo), y: 0)
                            .accessibilityElement(children: .ignore)
                            .accessibility(label: Text("\(word), \(word.count) letters"))
                        }
                    }
                }
                .frame(height: 500)
                
//                List(usedWords, id:\.self) { word in
//                    HStack {
//                        Image(systemName: "\(word.count).circle")
//                        Text(word)
//                    }
//                    .accessibilityElement(children: .ignore)
//                    .accessibility(label: Text("\(word), \(word.count) letters"))
//                }
//                .frame(height: 500)
                
                HStack {
                    Text("Score: \(usedWords.count)(\(calculateScore()))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                        .padding()
                    Spacer()
                }
                
                Spacer()
            }
            .navigationBarTitle(rootWord)
            .navigationBarItems(leading: Button(action: self.startGame, label: { Text("ReStart") }))
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // Project 18 - Challenge 2
    func getOffset(listGeo: GeometryProxy, itemGeo: GeometryProxy) -> CGFloat {
        let itemPercent = getItemPercent(listGeo: listGeo, itemGeo: itemGeo)
        
        let thresholdPercent: CGFloat = 60
        let indent: CGFloat = 9
        
        if itemPercent > thresholdPercent {
            return (itemPercent - (thresholdPercent - 1)) * indent
        }
        return 0
    }
    
    // Project 18 - Challenge 3
    func getColor(listGeo: GeometryProxy, itemGeo: GeometryProxy) -> Color {
        let itemPercent = getItemPercent(listGeo: listGeo, itemGeo: itemGeo)
        
        let colorValue = Double(itemPercent / 100)
        
        return Color(red: 2 * colorValue, green: (1 - 2 * colorValue), blue: 0)
    }
    
    func getItemPercent(listGeo: GeometryProxy, itemGeo: GeometryProxy) -> CGFloat {
        let listHeight = listGeo.size.height
        let listStart = listGeo.frame(in: .global).minY
        let itemStart = itemGeo.frame(in: .global).minY
        
        let itemPercent = (itemStart - listStart) / listHeight * 100
        
        return itemPercent
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: ".txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
    
    func calculateScore() -> Int {
        let usedWordCount = usedWords.map { $0.utf16.count  }
        
        return usedWordCount.reduce(0) { $0+$1 }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !answer.isEmpty else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word.")
            return
        }
        
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word) && rootWord != word
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return  true
    }
    
    func isReal(word: String) -> Bool {
        guard word.count > 2 else { return false }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
