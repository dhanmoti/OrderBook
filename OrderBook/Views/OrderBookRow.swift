//
//  OrderBookRow.swift
//  OrderBook
//
//  Created by Dhan Moti on 19/5/25.
//

import SwiftUICore

struct OrderBookRow: View, Equatable {
    let entry: OrderBookEntry
//    let maxQuantity: Int

    static func == (lhs: OrderBookRow, rhs: OrderBookRow) -> Bool {
        lhs.entry == rhs.entry
    }

    var body: some View {
        HStack {
            if entry.side == .buy {
                Text("\(Int(entry.quantity))")
                    .foregroundColor(.primary)
                Spacer()
            }
            
            Text(String(format: "%.1f", entry.price))
                .foregroundColor(entry.side == .buy ? .green : .red)
                .frame(width: 80, alignment: .leading)
                .background(
                    GeometryReader { geo in
                        let barWidth = min(CGFloat(entry.quantity) / 10000, 1.0) * geo.size.width
                        RoundedRectangle(cornerRadius: 0)
                            .fill((entry.side == .buy ? Color.green.opacity(0.1) : Color.red.opacity(0.1)))
                            .frame(width: barWidth)
                            .alignmentGuide(entry.side == .buy ? .trailing: .leading) { _ in 0 }
                    }
                )
            
           
            
            if entry.side == .sell {
                Spacer()
                Text("\(Int(entry.quantity))")
                    .foregroundColor(.primary)
            }
            
        }
        .padding(.vertical, 4)
    }
}
