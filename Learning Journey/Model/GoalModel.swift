//
//  GoalStruct.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 01/05/1447 AH.
//
import SwiftData
import Foundation

enum GoalDurationType: String, Codable, CaseIterable {
    case week, month, year
    var freezeLimit: Int {
        switch self {
        case .week: return 2
        case .month: return 8
        case .year: return 96
        }
    }
    var estimatedDays: Int {
        switch self {
        case .week: return 7
        case .month: return 30  // or calculate dynamically
        case .year: return 365
        }
    }

}

enum DayState: String, Codable {
    case none
    case learned
    case frozen
}

@Model
class GoalDay {
  //  var id: UUID
    var date: Date
    var state: DayState

    init(date: Date, state: DayState) {
      //  self.id = UUID()
        self.date = date
        self.state = state
    }
}

@Model
class Goal {
   // var id: UUID
    var title: String
    var startDate: Date
    var durationType: GoalDurationType
    var totalDays: Int 
    var freezeLimit: Int
    var streakCount: Int
    var frozenCount: Int
    var lastLoggedDate: Date?
   // var days: [GoalDay]

    init(title: String, startDate: Date, durationType: GoalDurationType) {
      //  self.id = UUID()
        self.title = title
        self.startDate = startDate
        self.durationType = durationType
        self.freezeLimit = durationType.freezeLimit
        self.streakCount = 0
        self.frozenCount = 0
        self.lastLoggedDate = nil
        self.totalDays = durationType.estimatedDays
        //self.days = []
    }

    // Freeze limit based on duration type
}


