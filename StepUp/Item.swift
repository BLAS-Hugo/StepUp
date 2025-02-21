//
//  Item.swift
//  StepUp
//
//  Created by Hugo Blas on 21/02/2025.
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
