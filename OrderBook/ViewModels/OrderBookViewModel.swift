//
//  OrderBookViewModel.swift
//  OrderBook
//
//  Created by Dhan Moti on 19/5/25.
//

import Foundation
import Combine

@MainActor
class OrderBookViewModel: ObservableObject {
    @Published private(set) var bids: [OrderBookEntry] = []
    @Published private(set) var asks: [OrderBookEntry] = []
    
    private var connection: WebSocketConnection?
    private let decoder = JSONDecoder()

    init() {
        let url = URL(string: "wss://www.bitmex.com/realtime")!
        let ws = WebSocketTaskConnection(url: url)
        ws.delegate = self
        self.connection = ws
        ws.connect()
    }

    private func handle(message: String) {
        guard let data = message.data(using: .utf8) else { return }
        
        do {
            let decoded = try decoder.decode(OrderBookMessage.self, from: data)
                        
            var newBids: [OrderBookEntry] = []
            var newAsks: [OrderBookEntry] = []
            
            for entry in decoded.data {
                
                guard
                    let price = entry.price,
                    let size = entry.size,
                    let side = Side(rawValue: entry.side.lowercased())
                else { continue }
                
                let orderEntry = OrderBookEntry(id: entry.id,
                                                side: side,
                                                price: price,
                                                quantity: size)
                
                switch side {
                case .buy:
                    newBids.append(orderEntry)
                case .sell:
                    newAsks.append(orderEntry)
                }
            }
            
            // ✅ Ensure all published changes happen on main thread
            DispatchQueue.main.async {
                self.bids = newBids.sorted { $0.price > $1.price }.prefix(20).map { $0 }
                self.asks = newAsks.sorted { $0.price < $1.price }.prefix(20).map { $0 }
            }
            
        } catch {
            print("Decode error: \(error)")
        }
    }
    

    func subscribeToOrderBook() {
        let json: [String: Any] = [
            "op": "subscribe",
            "args": ["orderBookL2:XBTUSD"]
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

// MARK: - WebSocketConnectionDelegate
extension OrderBookViewModel: @preconcurrency WebSocketConnectionDelegate {
    func onConnected(connection: WebSocketConnection) {
        print("✅ Connected to WebSocket")
        subscribeToOrderBook()
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

    func onMessage(connection: WebSocketConnection, data: Data) {
        // Not used
    }
}
