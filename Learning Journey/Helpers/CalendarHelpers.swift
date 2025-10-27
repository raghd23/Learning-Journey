//
//  Helpers.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 01/05/1447 AH.
//

// CalendarHelpers.swift
import SwiftUI

struct CalendarHelpers {
    static let calendar = Calendar.current
    
    // MARK: - Date Formatting
    static func monthYearString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: date)
    }

    // MARK: - Date Shifting
    static func shiftMonth(_ date: Date, by delta: Int) -> Date {
        calendar.date(byAdding: .month, value: delta, to: date) ?? date
    }

    // MARK: - Weekdays for current week
    static func weekDays(for date: Date) -> [Date] {
        guard let interval = calendar.dateInterval(of: .weekOfMonth, for: date) else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: interval.start) }
    }

    // MARK: - Comparison
    static func isSameDay(_ d1: Date, _ d2: Date) -> Bool {
        calendar.isDate(d1, inSameDayAs: d2)
    }
}

// MARK: - Badge View Helper
struct BadgeView: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.9))
            }
        }
        .frame(width: 160, height: 64)
        .background(color.opacity(0.24))
        .cornerRadius(48)
    }
}


