//
//  CalendarGrid.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 06/05/1447 AH.
//
import SwiftUI

struct CalendarGrid: View {
    let month: Date
    let goalDays: [GoalDay]
    private let cal = CalendarHelpers.calendar

    private var daysInMonth: [Date] {
        CalendarHelpers.daysInMonth(for: month)
    }

    private var leadingSpaces: Int {
        CalendarHelpers.leadingSpaces(for: month)
    }

    var body: some View {
        VStack(spacing: 6) {
            // Weekday header
            HStack {
                ForEach(cal.shortWeekdaySymbols, id: \.self) { day in
                    Text(day.uppercased())
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }

            // Days grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 6) {
                // Placeholder cells for proper alignment
                ForEach(0..<leadingSpaces, id: \.self) { _ in
                    Color.clear.frame(width: 32, height: 32)
                }

                // Actual day cells
                ForEach(daysInMonth, id: \.self) { date in
                    let color = colorForDate(date)
                    Text("\(cal.component(.day, from: date))")
                        .frame(width: 40, height: 40)
                        .font(.system(size: 20, weight: .medium))

                        .background(color.opacity(color == .clear ? 0 : 0.3))
                        .clipShape(Circle())
                        .foregroundColor(dayTextColor(for: color))
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }

    // MARK: - State-based color
    private func colorForDate(_ date: Date) -> Color {
        if let match = goalDays.first(where: { CalendarHelpers.isSameDay($0.date, date) }) {
            switch match.state {
            case .learned: return .orange
            case .frozen:  return .cyan
            case .none:    return .clear
            }
        }
        return .clear
    }
    
    private func dayTextColor(for color: Color) -> Color {
        color == .clear ? .white : color
    }

}
