//
//  Calander.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 28/04/1447 AH.
//

import Foundation
import SwiftUI
import SwiftData

struct CalendarView: View {
    var goal: Goal? // 🟠 Injected from ActivityPage (viewModel.currentGoal)
    @Query var allDays: [GoalDay]
    @State var currentDate = Date()
    @State var showPicker = false
    
    private let calendar = Calendar.current
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
             
                HStack {
                    Button {
                        withAnimation(.spring()) { showPicker.toggle() }
                    } label: {
                        HStack(spacing: 6) {
                            Text(CalendarHelpers.monthYearString(currentDate))
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.orange)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Button {
                            currentDate = CalendarHelpers.shiftWeek(currentDate, by: -1)
                        } label: {
                            Image(systemName: "chevron.left").foregroundColor(.orange)
                        }

                        Button {
                            currentDate = CalendarHelpers.shiftWeek(currentDate, by: 1)
                        } label: {
                            Image(systemName: "chevron.right").foregroundColor(.orange)
                        }
                    }
                }
                
                // MARK: Weekday row
                HStack(spacing: 8) {
                    ForEach(CalendarHelpers.calendar.shortWeekdaySymbols, id: \.self) {
                        Text($0.uppercased())
                            .font(.system(size: 16))
                            .foregroundColor(.primaryText.opacity(0.32))
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // MARK: Dynamic Week Display
                HStack(spacing: 8) {
                    ForEach(currentWeekDays(), id: \.self) { date in
                        let state = dayState(for: date)
                        let color = color(for: state)
                        Text("\(CalendarHelpers.calendar.component(.day, from: date))")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(dayTextColor(for: color))
                            .frame(width: 36, height: 36)
                            .background(color.opacity(0.3))
                            .clipShape(Circle())
                            .frame(maxWidth: .infinity)
                    }
                }
                
                Divider().background(.primaryText.opacity(0.32))
                
                // MARK: Goal summary
                if let goal = goal {
                    Text(goal.title)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 16) {
                        BadgeView(
                            icon: "flame.fill",
                            value: "\(goal.streakCount)",
                            label: goal.streakCount==1 ? Constants.oneDaysLearned: Constants.DaysLearned,
                            color: .orange
                        )
                        BadgeView(
                            icon: "cube.fill",
                            value: "\(goal.frozenCount)",
                            label: goal.frozenCount==1 ? Constants.oneDaysFreezed: Constants.DaysFreezed,
                            color: .cyan
                        )
                    }
                } else {
                    Text("No goal yet")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                }
            }
            .padding(20)
            .frame(width: 360, height: 256)
           // .background(Color.black.opacity(0.6))
            .cornerRadius(24)
            .background(RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.16),))
            .blur(radius: showPicker ? 3 : 0)
            
            
            // MARK: Popover Picker (unchanged)
            if showPicker {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.default) { showPicker = false }
                    }
                
                ZStack {
                    MonthYearPicker(date: $currentDate)
                        .frame(width: 260, height: 180)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.orange.opacity(0.0), lineWidth: 1)
                        )
                }
                .transition(.scale)
               // .zIndex(1)
            }
        }
    }
}

    

#Preview {
    CalendarView()
        
}
