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
            
            HStack(alignment: .center, spacing: 0) {
                // Buy orders
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 2) {
                        ForEach(viewModel.bids) { entry in
                            OrderBookRow(entry: entry, maxPrice: viewModel.maxBidPrice)
                        }
                    }
                }

                // Sell orders
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 2) {
                        ForEach(viewModel.asks) { entry in
                            OrderBookRow(entry: entry, maxPrice: viewModel.maxAskPrice)
                        }
                    }
                } 
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
