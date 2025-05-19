//
//  ContentView.swift
//  OrderBook
//
//  Created by Dhan Moti on 19/5/25.
//

import SwiftUI

enum Tab {
    case orderBook, recentTrades
}

struct ContentView: View {
    @State private var selectedTab: Tab = .orderBook
    
    var body: some View {
        VStack {
            Picker("Tab", selection: $selectedTab) {
                Text("Order Book").tag(Tab.orderBook)
                Text("Recent Trades").tag(Tab.recentTrades)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            switch selectedTab {
            case .orderBook:
                OrderBookView()
            case .recentTrades:
                RecentTradesView()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
