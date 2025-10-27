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
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = GoalViewModel()
    
    @State private var learnerGoal: String = ""
    @State private var selected: GoalDurationType = .week

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            VStack {
                ZStack {
                    Circle()
                        .background(
                            RoundedRectangle(cornerRadius: 56)
                                .stroke(Color.orange.opacity(0.2), lineWidth: 2)
                            )
                        .glassEffect(.clear.tint(.orange.opacity(0.08)))
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

                    FormView(learnerGoal: $learnerGoal, selected: $selected)
                }

                Spacer().frame(height: 160)
                Button(Constants.startLearning) {
                    guard !learnerGoal.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                                     viewModel.addGoal(title: learnerGoal, duration: selected, context: context)
                                     hasSeenOnboarding = true
                }
                .frame(width: 160, height: 48)
                .foregroundColor(.primaryText)
                .cornerRadius(32)
                .glassEffect(.clear.tint(.orange.opacity(0.56)).interactive())
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ContentView()

}
