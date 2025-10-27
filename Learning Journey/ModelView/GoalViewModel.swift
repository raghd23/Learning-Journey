//
//  GoalViewModel.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 05/05/1447 AH.
//

import SwiftUI
import SwiftData
import Combine

@MainActor
class GoalViewModel: ObservableObject {
    @Published var currentGoal: Goal?

    // MARK: - Fetch the existing Goal (only one)
    func fetchCurrentGoal(context: ModelContext) {
        if let existing = try? context.fetch(FetchDescriptor<Goal>()).first {
            currentGoal = existing
        }
    }

    // MARK: - Create or Update the single Goal
    func addGoal(title: String, duration: GoalDurationType, context: ModelContext) {
        if let existing = try? context.fetch(FetchDescriptor<Goal>()).first {
            // Update existing goal
            existing.title = title
            existing.durationType = duration
            existing.freezeLimit = duration.freezeLimit
            existing.totalDays = duration.estimatedDays
            existing.startDate = .now
            existing.streakCount = 0
            existing.frozenCount = 0
            existing.lastLoggedDate = nil
            try? context.save()
            currentGoal = existing
        } else {
            // First-time creation
            let goal = Goal(title: title, durationType: duration)
            context.insert(goal)
            try? context.save()
            currentGoal = goal
        }
    }

    // MARK: - Logging actions (days are separate SwiftData entities)
    func logLearn(for goal: Goal, context: ModelContext) {
        let today = Calendar.current.startOfDay(for: Date())
        guard !hasLoggedToday(context: context) else { return }

        // 32-hour idle rule → reset streak if inactive
        if let last = goal.lastLoggedDate,
           Date().timeIntervalSince(last) > (32 * 60 * 60) {
            goal.streakCount = 0
        }

        context.insert(GoalDay(date: today, state: .learned))
        goal.streakCount += 1
        goal.lastLoggedDate = today
        try? context.save()
    }

    func logFreeze(for goal: Goal, context: ModelContext) {
        let today = Calendar.current.startOfDay(for: Date())
        guard !hasLoggedToday(context: context),
              goal.frozenCount < goal.freezeLimit else { return }

        context.insert(GoalDay(date: today, state: .frozen))
        goal.frozenCount += 1
        goal.lastLoggedDate = today
        try? context.save()
    }

    // MARK: - State checkers
    func hasLoggedToday(context: ModelContext) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let descriptor = FetchDescriptor<GoalDay>()
        guard let allDays = try? context.fetch(descriptor) else { return false }
        return allDays.contains { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }

    var totalDays: Int {
        currentGoal?.totalDays ?? 0
    }

    var progress: Double {
        guard let g = currentGoal else { return 0 }
        let total = Double(g.streakCount + g.frozenCount)
        return total / Double(g.totalDays)
    }

    var isGoalComplete: Bool {
        guard let g = currentGoal else { return false }
        return g.streakCount + g.frozenCount >= g.totalDays
    }

    // MARK: - Reset / Delete
    func resetStreak(for goal: Goal, context: ModelContext) {
        goal.streakCount = 0
        goal.lastLoggedDate = nil
        try? context.save()
    }

    func resetGoal(context: ModelContext) {
        if let goals = try? context.fetch(FetchDescriptor<Goal>()) {
            for g in goals { context.delete(g) }
        }
        if let days = try? context.fetch(FetchDescriptor<GoalDay>()) {
            for d in days { context.delete(d) }
        }
        try? context.save()
        currentGoal = nil
    }
}
