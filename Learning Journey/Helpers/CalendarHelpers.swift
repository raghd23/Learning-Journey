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
    static func shiftWeek(_ date: Date, by delta: Int) -> Date {
        calendar.date(byAdding: .weekOfYear, value: delta, to: date) ?? date
    }
    
    static func startOfWeek(for date: Date) -> Date {
        calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) ?? date
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

    // MARK: - Month Utilities
    static func nextMonths(count: Int = 3) -> [Date] {
        (0..<count).compactMap { offset in
            calendar.date(byAdding: .month, value: offset, to: Date())
        }
    }

    static func makeDate(year: Int, month: Int, day: Int) -> Date {
        calendar.date(from: DateComponents(year: year, month: month, day: day))!
    }

    static func daysInMonth(for month: Date) -> [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: month),
              let start = calendar.date(from: calendar.dateComponents([.year, .month], from: month))
        else { return [] }
        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: start)
        }
    }

    static func leadingSpaces(for month: Date) -> Int {
        guard let firstDay = daysInMonth(for: month).first else { return 0 }
        let weekdayIndex = calendar.component(.weekday, from: firstDay) - calendar.firstWeekday
        return weekdayIndex < 0 ? weekdayIndex + 7 : weekdayIndex
    }
    
        
}


