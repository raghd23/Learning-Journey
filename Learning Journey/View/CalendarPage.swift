//
//  Calendar.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 04/05/1447 AH.
//

import SwiftUI
import SwiftData


struct CalendarPage: View {
    @Query private var allDays: [GoalDay] // ✅ SwiftData live fetch

    private let months: [Date] = {
        let calendar = Calendar.current
        let now = Date()
        return (0..<3).compactMap { offset in
            calendar.date(byAdding: .month, value: offset, to: now)
        }
    }()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                ForEach(months, id: \.self) { month in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(month, format: .dateTime.month().year())
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        CalendarGrid(
                            month: month,
                            goalDays: allDays // ✅ pass fetched SwiftData records
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("All Activities")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CalendarGrid: View {
    let month: Date
    let goalDays: [GoalDay] // ✅ All logged days
    private let cal = Calendar.current

    private var daysInMonth: [Date] {
        guard let range = cal.range(of: .day, in: .month, for: month),
              let start = cal.date(from: cal.dateComponents([.year, .month], from: month))
        else { return [] }
        return range.compactMap { day in cal.date(byAdding: .day, value: day - 1, to: start) }
    }

    // ✅ Compute leading padding based on first weekday of the month
    private var leadingSpaces: Int {
        guard let firstDay = daysInMonth.first else { return 0 }
        // Make Sunday = 0, Monday = 1, etc. for alignment
        let weekdayIndex = cal.component(.weekday, from: firstDay) - cal.firstWeekday
        return weekdayIndex < 0 ? weekdayIndex + 7 : weekdayIndex
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
                // 🟠 Empty placeholders for correct alignment
                ForEach(0..<leadingSpaces, id: \.self) { _ in
                    Color.clear.frame(width: 32, height: 32)
                }

                // 🟢 Actual days
                ForEach(daysInMonth, id: \.self) { date in
                    let color = colorForDate(date)
                    Text("\(cal.component(.day, from: date))")
                        .frame(width: 32, height: 32)
                        .background(color.opacity(color == .clear ? 0 : 0.8))
                        .clipShape(Circle())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }

    private func colorForDate(_ date: Date) -> Color {
        if let match = goalDays.first(where: { cal.isDate($0.date, inSameDayAs: date) }) {
            switch match.state {
            case .learned: return .orange.opacity(0.4)
            case .frozen:  return .cyan.opacity(0.4)
            case .none:    return .clear
            }
        }
        return .clear
    }
}

// MARK: - Helper
fileprivate func makeDate(year: Int, month: Int, day: Int) -> Date {
    Calendar.current.date(from: DateComponents(year: year, month: month, day: day))!
}


#Preview {
    NavigationStack {
        CalendarPage()
    }
}
