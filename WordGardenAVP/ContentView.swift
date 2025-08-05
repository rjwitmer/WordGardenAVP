//
//  ContentView.swift
//  WordGardenAVP
//
//  Created by Bob Witmer on 2025-08-04.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @FocusState private var textFieldIsFocused: Bool
    @State private var wordsGuessed: Int = 0
    @State private var wordsMissed: Int = 0
    @State private var gameStatusMessage: String = "How Many Guesses to Uncover the Hidden Word?"
    @State private var currentWordIndex: Int = 0    // Index in wordsToGuess
    @State private var wordToGuess: String = ""
    @State private var currentLetterGuess: String = ""
    @State private var lettersGuessed: String = ""
    @State private var revealedWord: String = ""
    @State private var imageIndex: Int = 8
    @State private var imageName: String = "flower"
    @State private var playAgainHidden: Bool = true
    private let wordsToGuess: [String] = ["SWIFT",
                                          "DOG",
                                          "KITTY",
                                          "ALMANC",
                                          "SPANIEL",
                                          "TORNADO",
                                          "REFRIGERATOR"]
    
    var body: some View {
        VStack {
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Words Guessed: \(wordsGuessed)")
                    Text("Words Missed: \(wordsMissed)")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Words to Guess: \(wordsToGuess.count - (wordsGuessed + wordsMissed))")
                    Text("Words in Game: \(wordsToGuess.count)")
                }
            }
            .padding()
            
            Spacer()
            
            Text(gameStatusMessage)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            Text(revealedWord)
                .font(.title)
            if playAgainHidden {
                HStack {
                    TextField("", text: $currentLetterGuess)
                        .keyboardType(.asciiCapable)
                        .submitLabel(.done)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                        .onChange(of: currentLetterGuess, {
                            currentLetterGuess = currentLetterGuess.trimmingCharacters(in: .letters.inverted)
                            guard let lastChar = currentLetterGuess.last else {
                                return
                            }
                            currentLetterGuess = String(lastChar).uppercased()
                        })
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.automatic)
                        .frame(width: 60, height: 60)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(style: StrokeStyle(lineWidth: 2))
                        }
                        .focused($textFieldIsFocused)
                        .onSubmit {
                            // Make sure there is a guessed letter and not nil
                            guard currentLetterGuess != "" else {
                                return
                            }
                            guessALetter()
                        }
                    
                    Button("Guess a Letter:") {
                        guessALetter()
                    }
                    .disabled(currentLetterGuess.isEmpty)
                    .font(.title2)
                    .buttonBorderShape(.roundedRectangle)
                    .tint(Color.green)
                }
            } else {
                Button("Another Word?") {
                    
                    if currentWordIndex < wordsToGuess.count - 1 {
                        currentWordIndex += 1
                    } else {
                        currentWordIndex = 0
                    }
                }
                .font(.title2)
                .buttonBorderShape(.roundedRectangle)
                .tint(.green)
            }
            
            
            
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                Image(imageName + "\(imageIndex)")
                    .resizable()
                    .scaledToFit()
            }
        }
        .onAppear() {
            wordToGuess = wordsToGuess[currentWordIndex]
            // CREATE A STRING FROM A REPEATING VALUE
            revealedWord = "_" + String(repeating: " _", count: wordToGuess.count - 1)
        }
        //        .padding()
        
    }
    
    func guessALetter() {
        textFieldIsFocused = false
        lettersGuessed.append(currentLetterGuess)
        revealedWord = wordToGuess.map { letter in
            lettersGuessed.contains(letter) ? String(letter) : "_"
        }.joined(separator: " ")
        
        if !wordToGuess.contains(currentLetterGuess){
            if imageIndex > 0 {
                imageIndex -= 1
            } else {
                // You Failed
                imageIndex = 8
            }
        }
        currentLetterGuess = ""
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
