//
//  Calendar.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 04/05/1447 AH.
//

import SwiftUI
struct CalendarPage: View {
    // Generate current + next 6 months
    private let months: [Date] = {
        let calendar = Calendar.current
        let now = Date()
        return (0..<3).compactMap { offset in
            calendar.date(byAdding: .month, value: offset, to: now)
        }
    }()
    
    // Example learned/freeze days for demonstration
    let learnedDays: Set<Date> = [
        makeDate(year: 2025, month: 10, day: 2),
    ]
    
    let frozenDays: Set<Date> = [
        makeDate(year: 2025, month: 10, day: 3),
    ]
    
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
                            learnedDays: learnedDays,
                            frozenDays: frozenDays
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("All activities")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Calendar Grid
struct CalendarGrid: View {
    let month: Date
    let learnedDays: Set<Date>
    let frozenDays: Set<Date>
    
    private let cal = Calendar.current
    
    private var daysInMonth: [Date] {
        guard let range = cal.range(of: .day, in: .month, for: month),
              let start = cal.date(from: cal.dateComponents([.year, .month], from: month))
        else { return [] }
        return range.compactMap { day in cal.date(byAdding: .day, value: day - 1, to: start) }
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
                ForEach(daysInMonth, id: \.self) { date in
                    let color = dayColor(for: date)
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
    
    private func dayColor(for date: Date) -> Color {
        if learnedDays.contains(where: { cal.isDate($0, inSameDayAs: date) }) {
            return .orange
        } else if frozenDays.contains(where: { cal.isDate($0, inSameDayAs: date) }) {
            return .cyan
        } else {
            return .clear
        }
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
