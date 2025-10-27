//
//  GoalHelpers.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 04/05/1447 AH.
//

import SwiftUI

struct FormView: View {
    @Binding var learnerGoal: String
    @Binding var selected: GoalDurationType

    var body: some View {
        VStack(alignment: .leading) {
            Text(Constants.goal)
                .foregroundColor(.primaryText)
                .bold()

            TextField("e.g. Learn Swift", text: $learnerGoal)
                .font(.title3)
                .foregroundColor(.primaryText)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.primaryText.opacity(0.2))

            Spacer().frame(height: 16)
            Text(Constants.goalDuration)
                .foregroundColor(.primaryText)

            HStack {
                ForEach(GoalDurationType.allCases, id: \.self) { period in
                    Button(period.rawValue.capitalized) {
                        selected = period
                    }
                    .frame(width: 96, height: 48)
                    .foregroundColor(.primaryText)
                    .cornerRadius(32)
                    .glassEffect(.clear.tint(selected == period ? .orange.opacity(0.56) : .gray.opacity(0.1)).interactive())
                }
            }
        }
    }
}

import SwiftUI
import SwiftData

struct CompleteView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var viewModel: GoalViewModel
    @State private var navigateToGoalPage = false

    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Spacer()

            Image(systemName: "hands.and.sparkles.fill")
                .font(.system(size: 64))
                .foregroundColor(.orange)
                .padding(.bottom, 12)
            
            Text(Constants.congratMassage)
                .foregroundColor(.primaryText)
                .bold()
                .font(.title)
            
            Text(Constants.congratMassage2)
                .foregroundColor(.secondaryText)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            // 🧭 New goal → navigate to goal page
            Button(Constants.SetNewGoal) {
                navigateToGoalPage = true
            }
            .frame(width: 320, height: 48)
            .foregroundColor(.primaryText)
            .cornerRadius(32)
            .glassEffect(.regular.tint(.accent.opacity(0.56)).interactive())
            
            // 🔁 Same goal → automated reset
            Button(Constants.SetSameGoal) {
                if let goal = viewModel.currentGoal {
                    // Reset streaks but keep goal title/duration
                    viewModel.addGoal(
                        title: goal.title,
                        duration: goal.durationType,
                        context: context
                    )
                }
            }
            .foregroundColor(.accent)
            
            Spacer()
        }
        .padding()
        .navigationDestination(isPresented: $navigateToGoalPage) {
            GoalPage(viewModel: viewModel)
        }
    }
}
