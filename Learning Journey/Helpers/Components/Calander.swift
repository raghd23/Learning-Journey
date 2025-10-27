//
//  Calander.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 28/04/1447 AH.
//

import Foundation
import SwiftUI


struct CalendarView: View {
    @State private var currentDate = Date()
    @State private var showPicker = false

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                // Header
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
                        Button { currentDate = CalendarHelpers.shiftMonth(currentDate, by: -1) } label: {
                            Image(systemName: "chevron.left").foregroundColor(.orange)
                        }
                        Button { currentDate = CalendarHelpers.shiftMonth(currentDate, by: 1) } label: {
                            Image(systemName: "chevron.right").foregroundColor(.orange)
                        }
                    }
                }

                // Weekday row
                HStack(spacing: 10) {
                    ForEach(CalendarHelpers.calendar.shortWeekdaySymbols, id: \.self) {
                        Text($0.uppercased())
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                    }
                }

                // Example week
                HStack(spacing: 10) {
                    ForEach(CalendarHelpers.weekDays(for: currentDate), id: \.self) { d in
                        Text("\(CalendarHelpers.calendar.component(.day, from: d))")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                            .frame(width: 32, height: 32)
                            .background(Color.clear)
                            .clipShape(Circle())
                            .frame(maxWidth: .infinity)
                    }
                }

                Divider().background(.white.opacity(0.2))

                Text("Learning Swift")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                HStack(spacing: 16) {
                    BadgeView(icon: "flame.fill", value: "3", label: "Days Learned", color: .orange)
                    BadgeView(icon: "cube.fill", value: "1", label: "Day Freezed", color: .cyan)
                }
            }
            .padding(20)
            .frame(width: 360, height: 256)
            .background(Color.black.opacity(0.6))
            .cornerRadius(24)
            .blur(radius: showPicker ? 3 : 0)

            // Custom Popover
            if showPicker {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeOut) { showPicker = false }
                    }

                VStack {
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
                .zIndex(1)
            }
        }
    }
}

// MARK: - UIKit Wheel (Month | Year only)
struct MonthYearPicker: UIViewRepresentable {
    @Binding var date: Date

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: MonthYearPicker
        let months = Calendar.current.monthSymbols
        let years = Array(2000...2100)

        init(_ parent: MonthYearPicker) { self.parent = parent }

        func numberOfComponents(in pickerView: UIPickerView) -> Int { 2 }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            component == 0 ? months.count : years.count
        }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            component == 0 ? months[row] : "\(years[row])"
        }
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let cal = Calendar.current
            let mRow = pickerView.selectedRow(inComponent: 0)
            let yRow = pickerView.selectedRow(inComponent: 1)
            var comps = DateComponents()
            comps.year  = years[yRow]
            comps.month = mRow + 1
            comps.day   = 1
            if let newDate = cal.date(from: comps) { parent.date = newDate }
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate   = context.coordinator
        picker.setValue(UIColor.white, forKey: "textColor")
        picker.backgroundColor = .clear // 🔥 removes any white bg
        return picker
    }

    func updateUIView(_ uiView: UIPickerView, context: Context) {
        let cal = Calendar.current
        let m = cal.component(.month, from: date) - 1
        let y = cal.component(.year,  from: date)
        if let yIndex = context.coordinator.years.firstIndex(of: y) {
            uiView.selectRow(m, inComponent: 0, animated: false)
            uiView.selectRow(yIndex, inComponent: 1, animated: false)
        }
    }
}


#Preview {
    CalendarView()
        
}
