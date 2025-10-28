//
//  Calendar.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 06/05/1447 AH.
//


import SwiftUI

extension CalendarView {
    func currentWeekDays() -> [Date] {
        let startOfWeek = CalendarHelpers.startOfWeek(for: currentDate)
        let cal = CalendarHelpers.calendar
        return (0..<7).compactMap { offset in
            cal.date(byAdding: .day, value: offset, to: startOfWeek)
        }
    }
    func dayState(for date: Date) -> DayState {
        let cal = CalendarHelpers.calendar
        return allDays.first(where: { cal.isDate($0.date, inSameDayAs: date) })?.state ?? .none
    }

    func color(for state: DayState) -> Color {
        switch state {
        case .learned: return .orange
        case .frozen:  return .cyan
        case .none:    return .clear
        }
    }
    
    func dayTextColor(for color: Color) -> Color {
        color == .clear ? .white : color
    }
}
