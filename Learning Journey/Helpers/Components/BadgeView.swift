//
//  BadgeView.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 06/05/1447 AH.
//
import SwiftUI

struct BadgeView: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.9))
            }
        }
        .frame(width: 160, height: 64)
        .background(color.opacity(0.24))
        .cornerRadius(48)
    }
}
