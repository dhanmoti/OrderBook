//
//  RecentTradesViewModel.swift
//  OrderBook
//
//  Created by Dhan Moti on 20/5/25.
//

import Foundation
import Combine

@MainActor
class RecentTradesViewModel: ObservableObject {
    @Published var trades: [TradeEntry] = []

    private var connection: WebSocketConnection?
    private let dateFormatter = ISO8601DateFormatter()

    init() {
        let url = URL(string: "wss://www.bitmex.com/realtime")!
        let ws = WebSocketTaskConnection(url: url)
        ws.delegate = self
        self.connection = ws
        ws.connect()
        
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    }

    private func handle(message: String) {
        guard let data = message.data(using: .utf8) else { return }
        var newTrades: [TradeEntry] = []
        
        do {
            let decoder = JSONDecoder()
            let tradeMessage = try decoder.decode(TradeMessage.self, from: data)
            if let trades = tradeMessage.data {
                for trade in trades {
                    print("Timestamp: \(trade.timestamp), Symbol: \(trade.symbol), Price: \(trade.price), Side: \(trade.side)")
                    
                    if let timestamp = dateFormatter.date(from: trade.timestamp),
                       let side = Side(rawValue: trade.side.lowercased()) {
                        
                        let trade = TradeEntry(side: side,
                                               quantity: trade.size ?? 0,
                                               timestamp: timestamp,
                                               price: trade.price)
                        
                        newTrades.append(trade)
                    }
                }
            }
           


            // Add new trades to top, keep max 30
            let updated = (newTrades + trades).sorted { $0.timestamp > $1.timestamp }.prefix(30)
            DispatchQueue.main.async { [weak self] in
                self?.trades = Array(updated)
            }
            

        } catch {
            print("❌ Trade decode error: \(error)")
        }
    }

    private func subscribeToTrades() {
        let json: [String: Any] = [
            "op": "subscribe",
            "args": ["trade:XBTUSD"]
        ]
        if let data = try? JSONSerialization.data(withJSONObject: json),
           let text = String(data: data, encoding: .utf8) {
            connection?.send(text: text)
        }
    }

    func disconnect() {
        connection?.disconnect()
    }
}

extension RecentTradesViewModel: @preconcurrency WebSocketConnectionDelegate {
    func onConnected(connection: WebSocketConnection) {
        subscribeToTrades()
    }

    func onDisconnected(connection: WebSocketConnection, error: Error?) {
        print("🔌 Disconnected: \(error?.localizedDescription ?? "no error")")
    }

    func onError(connection: WebSocketConnection, error: Error) {
        print("⚠️ WebSocket Error: \(error)")
    }

    func onMessage(connection: WebSocketConnection, text: String) {
        handle(message: text)
    }

    func onMessage(connection: WebSocketConnection, data: Data) { }
}
