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
    @State private var currentWordIndex: Int = 0
    @State private var currentLetterGuess: String = ""
    @State private var imageName: String = "flower8"
    @State private var playAgainHidden: Bool = true
    @State private var wordsToGuess: [String] = ["SWIFT",
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
            
            // TODO: Switch to wordsToGuess[currentWordIndex]
            Text("_ _ _ _ _")
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
                        .frame(width: 30)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(style: StrokeStyle(lineWidth: 2))
                        }
                        .focused($textFieldIsFocused)
                        
                    Button("Guess a Letter:") {
                        // TODO: Guess a Letter button action here
                        textFieldIsFocused = false
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
                Image(imageName)
                    .resizable()
                    .scaledToFit()
            }
        }
//        .padding()

    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
