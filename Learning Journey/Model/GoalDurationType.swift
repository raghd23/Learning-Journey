import Foundation

enum GoalDurationType: String, Codable, CaseIterable {
    case week, month, year
}

enum DayState: String, Codable {
    case none, learned, frozen
}

struct GoalDay: Identifiable, Codable {
    let id: UUID = UUID()
    let date: Date
    var state: DayState = .none
}

struct Goal: Identifiable, Codable {
    let id: UUID = UUID()
    var title: String
    var startDate: Date
    var durationType: GoalDurationType
    var days: [GoalDay] = []
    
    var freezeLimit: Int {
        switch durationType {
        case .week: return 2
        case .month: return 8
        case .year: return 96
        }
    }
    
    var totalDays: Int {
        Goal.estimateTotalDays(for: startDate, type: durationType)
    }
    
    static func estimateTotalDays(for date: Date, type: GoalDurationType) -> Int {
        switch type {
        case .week:
            return 7
        case .month:
            let calendar = Calendar.current
            return calendar.range(of: .day, in: .month, for: date)?.count ?? 30
        case .year:
            return 365
        }
    }
}