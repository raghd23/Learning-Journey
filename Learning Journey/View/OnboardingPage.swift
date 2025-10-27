//
//  File.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 28/04/1447 AH.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack {
                ZStack {
                    Circle()
                        .glassEffect(.clear.tint(.orange.opacity(0.16)))
                        .frame(height: 104)
                    Image(systemName: "flame.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                }

                Spacer().frame(height: 80)

                VStack(alignment: .leading, spacing: 8) {
                    Text(Constants.welocomeMassage)
                        .foregroundColor(.primaryText)
                        .font(.largeTitle)
                        .bold()
                    Text(Constants.appDescreption)
                        .foregroundColor(.secondaryText)
                    Spacer().frame(height: 24)
                    FormView()
                }

                Spacer().frame(height: 160)

                Button(Constants.startLearning) {
                    // When tapped, mark onboarding as done
                    hasSeenOnboarding = true
                }
                .frame(width: 160, height: 48)
                .foregroundColor(.primaryText)
                .cornerRadius(32)
                .glassEffect(.clear.tint(.orange).interactive())
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ContentView()

}
