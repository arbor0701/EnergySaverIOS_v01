//
//  Item.swift
//  EnergySaverIOS_v01
//
//  Created by machine01 on 5/18/24.
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
