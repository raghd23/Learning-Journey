//
//  ActivityPage.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 28/04/1447 AH.
//

import Foundation
import SwiftUI

import SwiftUI

import SwiftUI

struct ActivityPage: View {
    @State private var navigateToCalendarPage = false
    @State private var navigateToGoalPage = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack {
                    CalendarView()
                    Spacer().frame(height: 24)
                    
                    Button(Constants.logLearned) {
                        // Action for learning
                    }
                    .font(.title)
                    .bold()
                    .frame(width: 272, height: 272)
                    .foregroundColor(.primaryText)
                    .cornerRadius(32)
                    .glassEffect(.clear.tint(.orange).interactive())
                    
                    Spacer().frame(height: 24)
                    
                    Button(Constants.logFreezed) {
                        // Action for freezing
                    }
                    .frame(width: 272, height: 48)
                    .foregroundColor(.primaryText)
                    .cornerRadius(32)
                    .glassEffect(.clear.tint(.cyan).interactive())
                    
                    Text(Constants.FreezeCounter)
                        .foregroundColor(.secondaryText)
                }
            }
            .toolbar {
                // Calendar button → navigates to CalendarPage
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        navigateToCalendarPage = true
                    } label: {
                        Image(systemName: "calendar")
                            .foregroundStyle(.primaryText)
                    }
                    .glassEffect(.clear)
                }
                
                ToolbarSpacer(.fixed, placement: .primaryAction)
                
                // Pencil button → navigates to GoalPage
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        navigateToGoalPage = true
                    } label: {
                        Image(systemName: "pencil.and.outline")
                            .foregroundStyle(.primaryText)
                    }
                    .glassEffect(.clear)
                }
            }
            // Navigation destinations
            .navigationDestination(isPresented: $navigateToCalendarPage) {
                CalendarPage()
            }
            .navigationDestination(isPresented: $navigateToGoalPage) {
                GoalPage()
            }
            .navigationTitle("Activity")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ActivityPage()
        .preferredColorScheme(.dark)
}
