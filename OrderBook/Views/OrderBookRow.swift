//
//  OrderBookRow.swift
//  OrderBook
//
//  Created by Dhan Moti on 19/5/25.
//

import SwiftUICore

struct OrderBookRow: View {
    let entry: OrderBookEntry
    
    var body: some View {
        HStack {
            Text(String(format: "%.2f", entry.price))
                .foregroundColor(entry.side == .buy ? .green : .red)
                .frame(width: 80, alignment: .leading)
            
            Spacer()
            
            Text("\(Int(entry.quantity))")
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
        .background(
            GeometryReader { geo in
                let barWidth = min(CGFloat(entry.quantity) / 10000, 1.0) * geo.size.width
                RoundedRectangle(cornerRadius: 4)
                    .fill((entry.side == .buy ? Color.green.opacity(0.2) : Color.red.opacity(0.2)))
                    .frame(width: barWidth)
                    .alignmentGuide(.leading) { _ in 0 }
            }
        )
    }
}
