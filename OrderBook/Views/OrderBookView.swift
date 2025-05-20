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
            HStack(spacing: 16) {
                Text("Qty")
                Spacer()
                Text("Price (USD)")
                Spacer()
                Text("Qty")
            }
            
            // Separator line
            Color.black.opacity(0.2).frame(height: 0.5)
            
            HStack(alignment: .top, spacing: 16) {
                // Buy orders
                VStack(alignment: .leading) {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 2) {
                            ForEach(viewModel.bids) { entry in
                                OrderBookRow(entry: entry, maxPrice: viewModel.maxBidPrice)
                            }
                        }
                    }
                }
                .padding(0)

                // Sell orders
                VStack(alignment: .leading) {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 2) {
                            ForEach(viewModel.asks) { entry in
                                OrderBookRow(entry: entry, maxPrice: viewModel.maxAskPrice)
                            }
                        }
                    }
                }
                .padding(0)
            }
            .padding(.horizontal)
        }
//        .onAppear {
//            viewModel.connect()
//        }
//        .onDisappear {
//            viewModel.disconnect()
//        }
    }
}
