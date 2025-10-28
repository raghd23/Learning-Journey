//
//  MonthYearPicker.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 06/05/1447 AH.
//

import SwiftUI

struct MonthYearPicker: UIViewRepresentable {
    @Binding var date: Date

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: MonthYearPicker
        let months = Calendar.current.monthSymbols
        let years = Array(2000...2050)

        init(_ parent: MonthYearPicker) { self.parent = parent }

        func numberOfComponents(in pickerView: UIPickerView) -> Int { 2 }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            component == 0 ? months.count : years.count
        }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            component == 0 ? months[row] : "\(years[row])"
        }
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            var comps = DateComponents()
            comps.year  = years[pickerView.selectedRow(inComponent: 1)]
            comps.month = pickerView.selectedRow(inComponent: 0) + 1
            comps.day   = 1
            if let newDate = Calendar.current.date(from: comps) {
                parent.date = newDate
            }
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate   = context.coordinator
        picker.setValue(UIColor.primaryText, forKey: "textColor")
        picker.backgroundColor = .clear
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
