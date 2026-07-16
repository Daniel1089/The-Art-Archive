//
//  ArchiveView.swift
//  MyApp
//
//  Created by Daniel on 22/6/26.
//

import Foundation
import SwiftUI

struct ArchiveView: View {
    @State private var selection: String = "All"
    @State private var searchText: String = ""
    @State private var itemCategories: [String] = ["All", "Roman", "British", "Italian", "French", "Chinese", "American", "Japanese", "Greek"]
    @State private var isSearchExpanded: Bool = false
    @State private var isSearchActivated: Bool = false

    var body: some View {
        NavigationStack{
            ScrollView(.vertical){
                CardStackView()
                    .safeAreaPadding(.top, 5)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 6){
                        HStack{
                            Text("Archive")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        segmentedBar(items: $itemCategories, selection: $selection)
                    }
                    .padding(.top, 20)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
