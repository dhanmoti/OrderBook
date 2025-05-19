//
//  OrderBookMessage.swift
//  OrderBook
//
//  Created by Dhan Moti on 19/5/25.
//

// OrderBookMessage.swift
struct OrderBookMessage: Decodable {
//    let table: String
//    let action: String
    let data: [OrderBookRawEntry]
}

struct OrderBookRawEntry: Decodable {
    let id: Int
    let symbol: String
    let side: String
    let size: Int?
    let price: Double?
}

/*
 {
   "table": "orderBookL2",
   "action": "partial",
   "data": [
     {
       "id": 8799284800,
       "symbol": "XBTUSD",
       "side": "Sell",
       "size": 1036,
       "price": 37075
     }
   ]
 }
 */
