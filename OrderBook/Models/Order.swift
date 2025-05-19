//
//  Order.swift
//  OrderBook
//
//  Created by Dhan Moti on 19/5/25.
//

import Foundation

struct Order {
    var id: UUID
    var side: Side
    var price: Double
    var quantity: Double
}
