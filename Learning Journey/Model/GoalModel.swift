//
//  GoalStruct.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 01/05/1447 AH.
//
//import SwiftData
//import Foundation
//
//enum GoalDurationType: String, Codable, CaseIterable {
//    case week, month, year
//    var freezeLimit: Int {
//        switch self {
//        case .week: return 2
//        case .month: return 8
//        case .year: return 96
//        }
//    }
//    var estimatedDays: Int {
//        switch self {
//        case .week: return 7
//        case .month: return 30  // or calculate dynamically
//        case .year: return 365
//        }
//    }
//
//}
//
//enum DayState: String, Codable {
//    case none
//    case learned
//    case frozen
//}
//
//@Model
//class GoalDay {
//  //  var id: UUID
//    var date: Date
//    var state: DayState
//
//    init(date: Date, state: DayState) {
//      //  self.id = UUID()
//        self.date = date
//        self.state = state
//    }
//}
//
//@Model
//class Goal {
//   // var id: UUID
//    var title: String
//    var startDate: Date
//    var durationType: GoalDurationType
//    var totalDays: Int 
//    var freezeLimit: Int
//    var streakCount: Int
//    var frozenCount: Int
//    var lastLoggedDate: Date?
//   // var days: [GoalDay]
//
//    init(title: String, startDate: Date, durationType: GoalDurationType) {
//      //  self.id = UUID()
//        self.title = title
//        self.startDate = startDate
//        self.durationType = durationType
//        self.freezeLimit = durationType.freezeLimit
//        self.streakCount = 0
//        self.frozenCount = 0
//        self.lastLoggedDate = nil
//        self.totalDays = durationType.estimatedDays
//        //self.days = []
//    }
//
//    // Freeze limit based on duration type
//}

import Foundation
import SwiftData

// MARK: - Enums
enum GoalDurationType: String, Codable, CaseIterable {
    case week, month, year

    /// Number of freeze days allowed for each duration
    var freezeLimit: Int {
        switch self {
        case .week: return 2
        case .month: return 8
        case .year: return 96
        }
    }

    /// Estimated total days for the goal (for completion progress)
    var totalDays: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        case .year: return 365
        }
    }
}

enum DayState: String, Codable {
    case none, learned, frozen
}

// MARK: - GoalDay Model
@Model
class GoalDay {
    var id: UUID
    var date: Date
    var state: DayState
    @Relationship(inverse: \Goal.days) var goal: Goal?

    init(date: Date, state: DayState = .none) {
        self.id = UUID()
        self.date = date
        self.state = state
    }
}

// MARK: - Goal Model
@Model
class Goal {
    var id: UUID
    var title: String
    var startDate: Date
    var durationType: GoalDurationType

    // streak tracking
    var streakCount: Int
    var frozenCount: Int
    var lastLoggedDate: Date?

    // relationship with daily logs
    @Relationship var days: [GoalDay] = []

    init(
        title: String,
        startDate: Date,
        durationType: GoalDurationType
    ) {
        self.id = UUID()
        self.title = title
        self.startDate = startDate
        self.durationType = durationType
        self.streakCount = 0
        self.frozenCount = 0
    }

    // computed freeze limit
    var freezeLimit: Int {
        durationType.freezeLimit
    }

    // computed total days
    var totalDays: Int {
        durationType.totalDays
    }

    // check if user completed the goal (learned + frozen)
    var isComplete: Bool {
        return (streakCount + frozenCount) >= totalDays
    }

    // check if today already logged
    func hasLoggedToday() -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return days.contains { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
}


