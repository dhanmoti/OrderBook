//
//  Trade.swift
//  OrderBook
//
//  Created by Dhan Moti on 19/5/25.
//

import Foundation

struct Trade {
    let id: UUID
    let side: Side
    let quantity: Double
    let timestamp: Date
}
