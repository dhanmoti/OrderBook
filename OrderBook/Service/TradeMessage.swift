//
//  TradeMessage.swift
//  OrderBook
//
//  Created by Dhan Moti on 20/5/25.
//

struct TradeMessage: Codable {
    let table: String?
    let action: String?
    let data: [RawTradeEntry]?
}

struct RawTradeEntry: Codable {
    let timestamp: String
    let symbol: String
    let side: String
    let size: Int?
    let price: Double
    let trdMatchID: String

    enum CodingKeys: String, CodingKey {
        case timestamp, symbol, side, size, price, trdMatchID
    }
}

/*
 {
   "table": "trade",
   "action": "insert",
   "data": [
     {
       "timestamp": "2025-05-20T03:08:00.152Z",
       "symbol": "XBTUSD",
       "side": "Buy",
       "size": 1000,
       "price": 106043.1,
       "tickDirection": "MinusTick",
       "trdMatchID": "00000000-006d-1000-0000-0018602ccd15",
       "grossValue": 943010,
       "homeNotional": 0.0094301,
       "foreignNotional": 1000,
       "trdType": "Regular"
     }
   ]
 }
 */
