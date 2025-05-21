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
    
    private(set) var maxBidPrice: Double = 0.0
    private(set) var maxAskPrice: Double = 0.0
    
    private var pendingBids: [OrderBookEntry]?
    private var pendingAsks: [OrderBookEntry]?
    private let batchInterval: TimeInterval = 0.05
    private var isBatchingUpdates = false
    
    private var connection: WebSocketConnection?
    private let decoder = JSONDecoder()

    init() {
        let url = URL(string: "wss://www.bitmex.com/realtime")!
        let ws = WebSocketTaskConnection(url: url)
        ws.delegate = self
        self.connection = ws
        ws.connect()
    }
    
    deinit {
        self.connection?.disconnect()
    }

    private func handle(message: String) {
        guard let data = message.data(using: .utf8) else { return }
        
        do {
            let decoded = try decoder.decode(OrderBookMessage.self, from: data)
            
            guard decoded.table == "orderBookL2", decoded.action == "partial" || decoded.action == "insert" else { return }
                        
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
            
            let sortedBids = newBids.sorted { $0.totalPrice < $1.totalPrice }.prefix(20).map { $0 }
            let sortedAsks = newAsks.sorted { $0.totalPrice < $1.totalPrice }.prefix(20).map { $0 }
            handleWebSocketUpdate(newBids: sortedBids, newAsks: sortedAsks)
            
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
    
    func connect() {
        connection?.connect()
    }
}

// MARK: - batching updates
extension OrderBookViewModel {
    func handleWebSocketUpdate(newBids: [OrderBookEntry], newAsks: [OrderBookEntry]) {
        if isBatchingUpdates {
            pendingBids = newBids
            pendingAsks = newAsks
        } else {
            isBatchingUpdates = true
            pendingBids = newBids
            pendingAsks = newAsks

            DispatchQueue.main.asyncAfter(deadline: .now() + batchInterval) {
                self.bids = self.pendingBids ?? self.bids
                self.asks = self.pendingAsks ?? self.asks
                
                self.maxBidPrice = self.bids.last?.totalPrice ?? 0
                self.maxAskPrice = self.asks.last?.totalPrice ?? 0
                
                self.pendingBids = nil
                self.pendingAsks = nil
                self.isBatchingUpdates = false
            }
        }
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
