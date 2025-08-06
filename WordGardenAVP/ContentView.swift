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
    private static let maxGuesses: Int = 8  // Maximum Guesses - Need to refer to this as Self.maximumGuesses
    
    @FocusState private var textFieldIsFocused: Bool
    @State private var wordsGuessed: Int = 0
    @State private var wordsMissed: Int = 0
    @State private var gameStatusMessage: String = "How Many Guesses to Uncover the Hidden Word?"
    @State private var currentWordIndex: Int = 0    // Index in wordsToGuess
    @State private var wordToGuess: String = ""
    @State private var currentLetterGuess: String = ""
    @State private var lettersGuessed: String = ""
    @State private var revealedWord: String = ""
    @State private var guessesRemaining: Int = maxGuesses
    @State private var imageName: String = "flower\(maxGuesses)"
    @State private var playAgainHidden: Bool = true
    @State private var playAgainButtonLabel: String = "Another Word?"
    private let wordsToGuess: [String] = ["SWIFT",
                                          "DOG",
                                          "KITTY",
                                          "ALMANAC",
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
                .frame(height: 80)
                .minimumScaleFactor(0.5)
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
                            updateGamePlay()
                        }
                    
                    Button("Guess a Letter:") {
                        guessALetter()
                        updateGamePlay()
                    }
                    .disabled(currentLetterGuess.isEmpty)
                    .font(.title2)
                    .buttonBorderShape(.roundedRectangle)
                    .tint(Color.green)
                }
            } else {
                Button(playAgainButtonLabel) {
                    playAgainHidden = true
                    if currentWordIndex < wordsToGuess.count - 1 {
                        wordToGuess = wordsToGuess[currentWordIndex]
                        lettersGuessed = ""
                        gameStatusMessage = "How Many Guesses to Uncover the Hidden Word?"
                        revealedWord = "_" + String(repeating: " _", count: wordToGuess.count - 1)
                        guessesRemaining = Self.maxGuesses
                        imageName = "flower\(guessesRemaining)"
                    } else {
                        gameStatusMessage = "Sorry, no more words to play with!"
                        playAgainHidden = false
                        playAgainButtonLabel = "Reset Game?"
                        currentWordIndex = 0
                        wordsGuessed = 0
                        wordsMissed = 0
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

    }
    
    func updateGamePlay() {
        //TODO: Redo this with LocalizedStringKey and Inflect
        gameStatusMessage = "You've Made \(lettersGuessed.count) Guess\(lettersGuessed.count == 1 ? "" : "es")"
        
        if !wordToGuess.contains(currentLetterGuess){
            if guessesRemaining > 1 {
                guessesRemaining -= 1
                imageName = "flower\(guessesRemaining)"
            } else {
                // Word Missed
                gameStatusMessage += "\nYou Lose! The word was: \(wordToGuess)"
                imageName = "flower0"
                wordsMissed += 1
                currentWordIndex += 1
                playAgainHidden = false
                guessesRemaining = 8
            }
        }
        // Check if all Letters are correctly guessed
        if !revealedWord.contains("_") {
            gameStatusMessage += "\nYou Win!"
            wordsGuessed += 1
            currentWordIndex += 1
            playAgainHidden = false
        }
        currentLetterGuess = ""
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
