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
        VStack(alignment: .leading) {
            Text("Recent Trades")
                .font(.title2)
                .bold()
                .padding(.horizontal)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 4) {
                    ForEach(viewModel.trades) { trade in
                        TradeRow(trade: trade)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
