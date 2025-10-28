//
//  GoalViewModel.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 05/05/1447 AH.
//

import SwiftUI
import SwiftData
import Combine


import Foundation
import SwiftData
import SwiftUI

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
            //  Update current goal
            existing.title = title
            existing.durationType = duration
            existing.startDate = .now
            existing.streakCount = 0
            existing.frozenCount = 0
            existing.lastLoggedDate = nil
            try? context.save()
            currentGoal = existing
        } else {
            // First time create goal
            let goal = Goal(title: title, startDate: .now, durationType: duration)
            context.insert(goal)
            try? context.save()
            currentGoal = goal
        }
    }

    // MARK: - Logging Actions
    func logLearn(for goal: Goal, context: ModelContext) {
        let today = Calendar.current.startOfDay(for: Date())
        guard !goal.hasLoggedToday() else { return }

        if let last = goal.lastLoggedDate,
           Date().timeIntervalSince(last) > (32 * 60 * 60) {
            goal.streakCount = 0
        }

        let entry = GoalDay(date: today, state: .learned)
        entry.goal = goal
        goal.days.append(entry)
        goal.streakCount += 1
        goal.lastLoggedDate = today
        try? context.save()

        // forces UI to see the updated goal immediately
        fetchCurrentGoal(context: context)
    }

    func logFreeze(for goal: Goal, context: ModelContext) {
        let today = Calendar.current.startOfDay(for: Date())

        // Prevent duplicate or over-limit freezes
        guard !goal.hasLoggedToday(),
              goal.frozenCount < goal.freezeLimit else { return }

        let entry = GoalDay(date: today, state: .frozen)
        entry.goal = goal
        goal.days.append(entry)

        goal.frozenCount += 1
        goal.lastLoggedDate = today

        try? context.save()
        currentGoal = goal
    }

    // MARK: - Helpers
    func hasLoggedToday(context: ModelContext) -> Bool {
        currentGoal?.hasLoggedToday() ?? false
    }

    // MARK: - Reset / Cleanup
    func resetStreak(for goal: Goal, context: ModelContext) {
        goal.streakCount = 0
        goal.lastLoggedDate = nil
        try? context.save()
        currentGoal = goal
    }

    func resetGoal(context: ModelContext) {
        // Delete all goals and days
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
