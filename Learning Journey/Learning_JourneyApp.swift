//
//  Learning_JourneyApp.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 24/04/1447 AH.
//

import SwiftUI
import SwiftData

@main
struct Learning_JourneyApp: App {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    init() {
        // Makes all system alerts (UIAlertController) use this tint
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self])
            .tintColor = UIColor.systemOrange
    }

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ActivityPage()
            } else {
                ContentView()
            }
        }
    }
}
