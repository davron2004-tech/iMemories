//
//  Item.swift
//  iMemories
//
//  Created by Davron Abdukhakimov on 26/09/23.
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
