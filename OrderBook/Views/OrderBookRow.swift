//
//  OrderBookRow.swift
//  OrderBook
//
//  Created by Dhan Moti on 19/5/25.
//

import SwiftUICore

struct OrderBookRow: View, Equatable {
    let entry: OrderBookEntry
    let maxPrice: Double
    
    let barWidth: CGFloat = 80

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
            
            ZStack {
                let fillWidth = min((CGFloat(entry.totalPrice) / CGFloat(maxPrice)), 1.0) * barWidth
                HStack {
                    if entry.side == .buy {
                        Spacer()
                        Color.green.opacity(0.1)
                            .frame(width: fillWidth)
                    }
                    
                    if entry.side == .sell {
                        Color.red.opacity(0.1)
                            .frame(width: fillWidth)
                        Spacer()
                    }
                    
                }
                
                HStack {
                    if entry.side == .buy {
                        Spacer()
                    }
                    Text(String(format: "%.1f", entry.price))
                        .foregroundColor(entry.side == .buy ? .green : .red)
                        .frame(width: barWidth, alignment: .leading)
                        .background(Color.clear)
                    
                    if entry.side == .sell {
                        Spacer()
                    }
                }
            }
            .frame(width: barWidth)
            
           
            
            if entry.side == .sell {
                Spacer()
                Text("\(Int(entry.quantity))")
                    .foregroundColor(.primary)
            }
            
        }
        .padding(0)
    }
}
