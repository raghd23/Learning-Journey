//
//  GoalHelpers.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 04/05/1447 AH.
//

import SwiftUI


struct FormView: View {
    @State private var learnerGoal: String = ""
    @State private var selected = "week"
    
    var body: some View {
        
        Text(Constants.goal)
            .foregroundColor(.primaryText)
            .bold()
            //.font()
        //input
        TextField("Swift", text: $learnerGoal)
            .font(.title3)
            .foregroundColor(.primaryText)
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.primaryText.opacity(0.2))
                        
        Spacer().frame(height:16)
        
        Text(Constants.goalDuration)
            .foregroundColor(.primaryText)
           // .font(.headline)
        //options
        HStack {
            ForEach(["week", "month", "year"], id: \.self) { period in
                Button(period.capitalized) {
                    selected = period
                }
                .frame(width: 96, height: 48)
                .foregroundColor(.primaryText)
                .cornerRadius(32)
                .glassEffect(.clear.tint(selected == period ? .orange : .gray.opacity(0.1)).interactive())
            }
        }
    }
}
