//
//  Calendar.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 04/05/1447 AH.
//

import SwiftUI
import SwiftData


struct CalendarPage: View {
    @Query private var allDays: [GoalDay]  // ✅ Live SwiftData fetch for all logged days

    // Generate current + next 2 months
    private let months = CalendarHelpers.nextMonths(count: 4)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                ForEach(months, id: \.self) { month in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(CalendarHelpers.monthYearString(month))
                            .font(.headline)
                            .foregroundColor(.white)

                        CalendarGrid(month: month, goalDays: allDays)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("All Activities")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    NavigationStack {
        CalendarPage()
    }
}
