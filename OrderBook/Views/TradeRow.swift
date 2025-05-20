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
            Text(String(format: "%.2f", trade.price))
                .foregroundColor(trade.side == .buy ? .green : .red)
                .frame(width: 100, alignment: .leading)

            Spacer()

            Text("\(Int(trade.quantity))")
                .foregroundColor(.primary)

            Text(trade.timestamp.formatted(.dateTime.hour().minute().second()))
                .foregroundColor(.gray)
                .font(.caption)
                .frame(width: 80, alignment: .trailing)
        }
        .padding(6)
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
