//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Ruby Kim on 2024/04/08.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var restart = false
    @State private var played = 1
    @State private var scoreTitle = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var score = 0
    @State private var chosenFlag = ""
    @State private var selectedFlag = -1

    
    var body: some View {
        ZStack {
            AngularGradient(colors: [.red, .orange, .yellow, .green, .blue, .indigo, .purple, .red], center: .center)
                .ignoresSafeArea()
            VStack {
                Text("Guess The Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                Text("\(played)/8")
//                    .titleStyle()
                    .font(.title.weight(.bold))
                    .foregroundColor(.secondary)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.primary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            chosenFlag = countries[number]
                        }
                        label: {
                            FlagImage(text: countries[number])
                        }
                        .buttonStyle(ButtonPressedRotate())
                        .scaleEffect(selectedFlag == -1 || selectedFlag == number ? 1 : 0.6)
                        .opacity(selectedFlag == -1 || selectedFlag == number ? 1 : 0.25)
                    }

                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(Rectangle()).cornerRadius(20)
                .padding(40)
                
                Text("Score: \(score)")
                    .foregroundStyle(.secondary)
                    .font(.title.bold())
            }
        }
        
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            if (scoreTitle == "Correct") {
                Text("Congrats!\nYou've got +5 points.")
            } else {
                Text("Nope! That's the flag of \(chosenFlag).\nYou've got -5 points.")
            }
        }
        .alert("Your score is", isPresented: $restart) {
            Button("Restart", action: reset)
        } message: {
            Text("\(score)")
        }
    }
    
    func reset() {
        showingScore = false
        restart = false
        score = 0
        played = 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = -1
    }
    
    func flagTapped(_ number: Int) {
            if number == correctAnswer {
                scoreTitle = "Correct"
                score += 5
                selectedFlag = number
                
            } else {
                scoreTitle = "Wrong"
                score -= 5
            }
            showingScore = true
        }


    
    func askQuestion() {
        played += 1
        if played == 9 {
            played -= 1
            restart = true
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            selectedFlag = -1
        }
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.blue)
    }
}


struct FlagImage: View {
    var text: String
    
    var body: some View {
        Image(text)
            .clipShape(Capsule())
            .shadow(radius: 5)

    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct ButtonPressedRotate: ButtonStyle {
    @State private var rotation = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .rotation3DEffect(
                .degrees(configuration.isPressed ? 360 : 0),
                                      axis: (x: 1, y: 0, z: 0)
            )
            .animation(.easeOut(duration: 0.5), value: 1)
        
    }
}

