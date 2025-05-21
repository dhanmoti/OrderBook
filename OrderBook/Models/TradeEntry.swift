//
//  TradeEntry.swift
//  OrderBook
//
//  Created by Dhan Moti on 19/5/25.
//

import Foundation

struct TradeEntry: Identifiable {
    var id: String {
        side.rawValue + "_\(timestamp.timeIntervalSince1970)" + "_\(price)" + "_\(quantity)"
    }
    let side: Side
    let quantity: Int
    let timestamp: Date
    let price: Double
}

extension TradeEntry: Equatable {
    static func == (lhs: TradeEntry, rhs: TradeEntry) -> Bool {
        return lhs.id == rhs.id
    }
}
