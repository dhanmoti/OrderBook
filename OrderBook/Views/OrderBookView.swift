//
//  OrderBookView.swift
//  OrderBook
//
//  Created by Dhan Moti on 19/5/25.
//

import SwiftUI

struct OrderBookView: View {
    @StateObject private var viewModel = OrderBookViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("Order Book")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding(.horizontal)

            HStack(spacing: 16) {
                // BUY orders (bids)
                VStack(alignment: .leading) {
                    Text("Buy Orders")
                        .font(.headline)
                    List(viewModel.bids, id: \.id) { entry in
                        OrderBookRow(entry: entry)
                    }
                    .listStyle(.plain)
                }

                // SELL orders (asks)
                VStack(alignment: .leading) {
                    Text("Sell Orders")
                        .font(.headline)
                    List(viewModel.asks, id: \.id) { entry in
                        OrderBookRow(entry: entry)
                    }
                    .listStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
}
