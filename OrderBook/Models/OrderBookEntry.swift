//
//  OrderBookEntry.swift
//  OrderBookEntry
//
//  Created by Dhan Moti on 19/5/25.
//

import Foundation

struct OrderBookEntry {
    var id: Int
    var side: Side
    var price: Double
    var quantity: Int
}

extension OrderBookEntry: Equatable {
    static func == (lhs: OrderBookEntry, rhs: OrderBookEntry) -> Bool {
        return lhs.id == rhs.id && lhs.quantity == rhs.quantity
    }
}
