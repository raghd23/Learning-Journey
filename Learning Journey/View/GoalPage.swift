//
//  GoalChangePage.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 04/05/1447 AH.
//

import SwiftUI

struct GoalPage: View {
    var body: some View {
        VStack(alignment: .leading){
            Spacer().frame(height:56)
            FormView()
            Spacer()
        }
        .padding(16)
    }
}

#Preview {
    GoalPage()
}

