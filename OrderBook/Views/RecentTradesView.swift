//
//  RecentTradesView.swift
//  OrderBook
//
//  Created by Dhan Moti on 19/5/25.
//

import SwiftUI

struct RecentTradesView: View {
    @StateObject private var viewModel = RecentTradesViewModel()

    var body: some View {
        VStack {
            Text("Recent Trades")
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            HStack {
                Text("Price (USD)")
                    .frame(width: 100)
                Spacer()
                Text("Qty")
                    .frame(width: 100)
                Spacer()
                Text("Time")
                    .frame(width: 100)
            }
            
            // Separator line
            Color.black.opacity(0.2).frame(height: 0.5)

            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.trades) { trade in
                        TradeRow(trade: trade)
                    }
                }
            }
        }
    }
}
