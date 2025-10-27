//
//  GoalChangePage.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 04/05/1447 AH.
//

import SwiftUI

struct GoalPage: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var viewModel: GoalViewModel
    @State private var showingAlert = false
    @Environment(\.dismiss) private var dismiss

    @State private var learnerGoal: String = ""
    @State private var selected: GoalDurationType = .week


    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 56)

            // Your existing custom form
            FormView(learnerGoal: $learnerGoal, selected: $selected)

            Spacer()
        }
        .accentColor(.orange)
        .padding(16)
        .navigationTitle("Learning Goal")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // ✅ Check button — triggers alert
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAlert = true
                } label: {
                    Image(systemName: "checkmark.circle.fill").resizable()
                        .foregroundStyle(.orange).scaledToFit()
                        .frame(width: 36, height:36)
                        .glassEffect(.clear.tint(.orange.opacity(0.16))
                        )

                }
            }
        }
        // iOS-style alert popup
        .alert("Update Learning goal", isPresented: $showingAlert) {
            Button("Dismiss", role: .cancel) { }
            Button("Update", role: .confirm) {
                guard viewModel.currentGoal != nil else { return }
                viewModel.addGoal(title: learnerGoal, duration: selected, context: context)
            //    viewModel.resetStreak(for: goal, context: context)
                dismiss()
            }
        } message: {
            Text("If you update now, your streak will start over.")
        }
    }
   
}

#Preview {
 //   GoalPage()
}

