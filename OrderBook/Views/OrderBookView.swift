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

            HStack(alignment: .top, spacing: 16) {
                // Buy orders
                VStack(alignment: .leading) {
                    Text("Buy")
                        .font(.headline)
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 2) {
                            ForEach(viewModel.bids) { entry in
                                OrderBookRow(entry: entry)
                            }
                        }
                    }
                }

                // Sell orders
                VStack(alignment: .leading) {
                    Text("Sell")
                        .font(.headline)
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 2) {
                            ForEach(viewModel.asks) { entry in
                                OrderBookRow(entry: entry)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.connect()
        }
        .onDisappear {
            viewModel.disconnect()
        }
    }
}
