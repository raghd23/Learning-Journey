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
            ZStack (alignment: .top) {
                Color(.systemBackground).ignoresSafeArea()
                VStack {
                    CalendarView(goal: viewModel.currentGoal)
                    Spacer().frame(height: 24)

                    if viewModel.currentGoal?.isComplete == true
                    {
                        CompleteView(viewModel: viewModel) }
                    else {
                        
                    }// MARK: - Activity Buttons
                        let todayLoggedState: DayState? = {
                            guard let goal = viewModel.currentGoal else { return nil }
                            let today = Calendar.current.startOfDay(for: Date())
                            return goal.days.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) })?.state
                        }()

                        // 🟠 Determine visual style based on today's state
                        let learnedToday = todayLoggedState == .learned
                        let frozenToday  = todayLoggedState == .frozen
                        let nothingToday = todayLoggedState == nil

                        // MARK: - Main Learn Button
                        Button(
                            learnedToday ? "Learned Today" :
                            frozenToday  ? "Day Frozen" :
                            Constants.logLearned
                        ) {
                            if let goal = viewModel.currentGoal {
                                viewModel.logLearn(for: goal, context: context)
                            }
                        }
                        .font(.system(size: 44, weight: .bold))
                        .multilineTextAlignment(.center)
                        .frame(width: 272, height: 272)
                        .foregroundColor(
                            learnedToday ? .orange :
                            frozenToday  ? .cyan  :
                            .primaryText
                        )
                        .background(
                            Circle()
                                .stroke(
                                    learnedToday ? .orange.opacity(0.2) :
                                    frozenToday  ? .cyan.opacity(0.2) :
                                    .orange.opacity(0.4),
                                    lineWidth: 2
                                )
                        )
                        .glassEffect(
                            .clear.tint(
                                learnedToday ? .orange.opacity(0.1) :
                                frozenToday  ? .cyan.opacity(0.1) :
                                .orange.opacity(0.64)
                            ).interactive()
                        )
                        .disabled(viewModel.hasLoggedToday(context: context))

                        Spacer().frame(height: 24)

                        // MARK: - Freeze Button
                        Button(Constants.logFreezed) {
                            if let goal = viewModel.currentGoal {
                                viewModel.logFreeze(for: goal, context: context)
                            }
                        }
                        .frame(width: 272, height: 48)
                        .foregroundColor(.primaryText)
                        .background(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(
                                    viewModel.hasLoggedToday(context: context) ||
                                    (viewModel.currentGoal?.frozenCount ?? 0) >= (viewModel.currentGoal?.freezeLimit ?? 0)
                                    ? Color.cyan.opacity(0.3)
                                    : Color.cyan.opacity(0.4),
                                    lineWidth: 2
                                )
                        )
                        .cornerRadius(32)
                        .glassEffect(
                            .clear.tint(
                                frozenToday ? .cyan.opacity(0.1) :
                                .cyan.opacity(0.64)
                            ).interactive()
                        )
                        .disabled(
                            viewModel.hasLoggedToday(context: context) ||
                            (viewModel.currentGoal?.frozenCount ?? 0) >= (viewModel.currentGoal?.freezeLimit ?? 0)
                        )
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
            .navigationDestination(isPresented: $navigateToCalendarPage) {
                CalendarPage()  
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
