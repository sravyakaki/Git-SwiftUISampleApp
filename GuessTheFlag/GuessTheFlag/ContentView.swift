//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Sravya Kaki on 2024-12-03.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK","Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var currentScore = 0
    @State private var selectedCountry = ""
    @State private var numOfQuestions = 1
    @State private var showFinalScore = false
    @State private var tappedItemIndex: Int? = nil
    @State private var isButtonTapped = false
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green:0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red:0.76, green:0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700).ignoresSafeArea()
            VStack {
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of:")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(number: number, countries: countries)
                        }
                        .rotation3DEffect(.degrees(tappedItemIndex == number ? 360 : 0), axis: (x:0, y: 1, z: 0))
                        .opacity((isButtonTapped && tappedItemIndex != number) ? 0.25 : 1.00)
                        .scaleEffect((isButtonTapped && tappedItemIndex != number) ? 0.75 : 1.00)
                        .animation(.easeIn(duration: 1), value: tappedItemIndex)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical,20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                Text("Score: \(currentScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
            }.padding()
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            if(scoreTitle == "Wrong") {
                Text("""
Wrong! That's the flag of \(selectedCountry)     
Your score is \(currentScore)
""")
            } else {
                Text("Your score is \(currentScore)")
            }
            
        }
        .alert("Game Over", isPresented: $showFinalScore) {
            Button("Restart Game", action: finalScoreAlert )
        } message: {
            Text("Your final score is \(currentScore)")
        }
    }
    func flagTapped(_ number: Int) {
        tappedItemIndex = number
        isButtonTapped = true
        if(number == correctAnswer) {
            scoreTitle = "Correct"
            currentScore += 1
        } else {
            scoreTitle = "Wrong"
            currentScore -= 1
            selectedCountry = countries[number]
        }
        showingScore = true
    }
    
    func askQuestion() {
        tappedItemIndex = nil
        isButtonTapped = false
        if(numOfQuestions < 8) {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            numOfQuestions += 1
        } else {
            showFinalScore = true
        }
    }
    
    func finalScoreAlert() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        numOfQuestions = 1
        currentScore = 0
    }
    
}

#Preview {
    ContentView()
}


struct FlagImage: View
{
    var number: Int
    var countries: [String]
    var body: some View {
        Image(countries[number])
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}
