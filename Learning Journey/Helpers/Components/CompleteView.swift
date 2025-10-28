//
//  CompleteView.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 06/05/1447 AH.
//


import SwiftUI
import SwiftData

struct CompleteView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var viewModel: GoalViewModel
    @State private var navigateToGoalPage = false

    var body: some View {
        VStack(alignment: .center, spacing: 24) {
           
            Image(systemName: "hands.and.sparkles.fill")
                .font(.system(size: 64))
                .foregroundColor(.orange)
                //.padding(.bottom, 12)
            
            Text(Constants.congratMassage)
                .foregroundColor(.primaryText)
                .bold()
                .font(.title)
            
            Text(Constants.congratMassage2)
                .foregroundColor(.secondaryText)
                //.font(.headline)
                .multilineTextAlignment(.center)
                
            
            Spacer()
            
            // navigate to goal page
            Button(Constants.SetNewGoal) {
                navigateToGoalPage = true
            }
            .frame(width: 240, height: 48)
            .foregroundColor(.primaryText)
            .cornerRadius(32)
            .glassEffect(.regular.tint(.accent.opacity(0.56)).interactive())
            
            // reset Goal
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
            
           
        }
        .padding()
        .navigationDestination(isPresented: $navigateToGoalPage) {
            GoalPage(viewModel: viewModel)
        }
    }
}
