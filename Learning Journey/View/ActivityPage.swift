//
//  ActivityPage.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 28/04/1447 AH.
//

import Foundation
import SwiftUI

struct ActivityPage: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = GoalViewModel()
    @State private var navigateToCalendarPage = false
    @State private var navigateToGoalPage = false
    @State private var loggedToday = false
    var hasLoggedToday: Bool {
        if let date = viewModel.currentGoal?.lastLoggedDate {
            return Calendar.current.isDateInToday(date)
        }
        return false
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                VStack {
                    CalendarView(goal: viewModel.currentGoal)
                    Spacer().frame(height: 24)

                    Button("Log Learned") {
                        if let goal = viewModel.currentGoal {
                               viewModel.logLearn(for: goal, context: context)
                           }                    }
                    .font(.title)
                    .bold()
                    .frame(width: 272, height: 272)
                    .foregroundColor(.primaryText)
                    .background(
                        Circle()
                            .stroke(hasLoggedToday ? Color.gray.opacity(0.3) : Color.orange.opacity(0.0), lineWidth: 4)
                            .shadow(radius: hasLoggedToday ? 0 : 4)
                    )
                    .glassEffect(.clear.tint(hasLoggedToday ? .black : .orange).interactive())
                    .disabled(hasLoggedToday)

                    Spacer().frame(height: 24)
                    Button("Log Frozen") {
                        if let goal = viewModel.currentGoal {
                            viewModel.logFreeze(for: goal, state: .frozen, context: context)
                        }
                        loggedToday = true
                    }
                    .frame(width: 272, height: 48)
                    .foregroundColor(.primaryText)
                    .background(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(hasLoggedToday || (viewModel.currentGoal?.frozenCount ?? 0) >= (viewModel.currentGoal?.freezeLimit ?? 0)
                                    ? Color.gray.opacity(0.3) : Color.cyan, lineWidth: 2)
                    )
                    .cornerRadius(32)
                    .glassEffect(.clear.tint(hasLoggedToday ? .black : .cyan).interactive())
                    .disabled(hasLoggedToday || (viewModel.currentGoal?.frozenCount ?? 0) >= (viewModel.currentGoal?.freezeLimit ?? 0))

                    if let goal = viewModel.currentGoal {
                        Text("\(goal.frozenCount) out of \(goal.freezeLimit) Freezes Used")
                            .foregroundColor(.secondaryText)
                    }
                }
            }
            .onAppear {
                viewModel.fetchCurrentGoal(context: context)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        navigateToCalendarPage = true
                    } label: {
                        Image(systemName: "calendar")
                            .foregroundStyle(.primaryText)
                    }
                }
                ToolbarSpacer(.fixed, placement: .primaryAction)
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        navigateToGoalPage = true
                    } label: {
                        Image(systemName: "pencil.and.outline")
                            .foregroundStyle(.primaryText)
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToGoalPage) {
                GoalPage(viewModel: viewModel)
            }
            .navigationTitle("Activity")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
#Preview {
    ActivityPage()
        .preferredColorScheme(.dark)
}
