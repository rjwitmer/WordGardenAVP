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
                    TextField("?", text: $currentLetterGuess)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 30)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(style: StrokeStyle(lineWidth: 2))
                        }
                        
                    Button("Guess a Letter:") {
                        // TODO: Guess a Letter button action here
                        playAgainHidden = false
                    }
                    .font(.title2)
                    .buttonBorderShape(.roundedRectangle)
                    .tint(Color.blue)
                }
            } else {
                Button("Another Word?") {
                    playAgainHidden = true
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
