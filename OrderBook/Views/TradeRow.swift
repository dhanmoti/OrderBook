//
//  TradeRow.swift
//  OrderBook
//
//  Created by Dhan Moti on 20/5/25.
//

import SwiftUI

struct TradeRow: View {
    let trade: TradeEntry
    @State private var flash = true

    var body: some View {
        HStack {
            Text(String(format: "%.1f", trade.price))
                .foregroundColor(trade.side == .buy ? .green : .red)
                .frame(width: 100)

            Spacer()

            Text("\(Int(trade.quantity))")
                .foregroundColor(trade.side == .buy ? .green : .red)
                .frame(width: 100)
            
            Spacer()

            Text(trade.timestamp.formatted(.dateTime.hour().minute().second()))
                .foregroundColor(trade.side == .buy ? .green : .red).opacity(0.6)
                .font(.caption)
                .frame(width: 100)
        }
        .background(flash ? (trade.side == .buy ? Color.green.opacity(0.15) : Color.red.opacity(0.15)) : Color.clear)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation {
                    flash = false
                }
            }
        }
        .cornerRadius(6)
    }
}
