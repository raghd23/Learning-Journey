//
//  FormView.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 06/05/1447 AH.
//

import SwiftUI

struct FormView: View {
    @Binding var learnerGoal: String
    @Binding var selected: GoalDurationType

    var body: some View {
        VStack(alignment: .leading) {
            Text(Constants.goal)
                .foregroundColor(.primaryText)
                .bold()

            TextField("e.g. Learn Swift", text: $learnerGoal)
                .font(.title3)
                .foregroundColor(.primaryText)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.primaryText.opacity(0.2))

            Spacer().frame(height: 16)
            Text(Constants.goalDuration)
                .foregroundColor(.primaryText)

            HStack {
                ForEach(GoalDurationType.allCases, id: \.self) { period in
                    Button(period.rawValue.capitalized) {
                        selected = period
                    }
                    .frame(width: 96, height: 48)
                    .foregroundColor(.primaryText)
                    .cornerRadius(32)
                    .glassEffect(.clear.tint(selected == period ? .orange.opacity(0.56) : .gray.opacity(0.1)).interactive())
                }
            }
        }
    }
}
