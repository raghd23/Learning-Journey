//
//  Item.swift
//  Learning Journey
//
//  Created by Raghad Alzemami on 24/04/1447 AH.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
