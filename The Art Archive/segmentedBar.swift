//
//  segmentedBar.swift
//  The Art Archive
//
//  Created by Daniel on 27/6/26.
//

import SwiftUI
import Foundation

struct segmentedBar: View {
    @Binding var items: [String]
    @Binding var selection: String
    @Environment(\.colorScheme) var userScheme: ColorScheme
    
    var body: some View {
            ScrollView(.horizontal){
                HStack(spacing: 20){
                    ForEach(items, id: \.self){ item in
                        let isTheItemSelected: Bool = selection == item
                        
                        Button(action: {
                            selection = item
                        }, label: {
                            Text(item)
                                .font(.headline)
                                .padding(6)
                        })
                        .buttonBorderShape(.capsule)
                        .glassEffect(.clear.interactive(), in: .capsule)
                        .buttonStyle(.borderedProminent)
                        .tint(isTheItemSelected ?  (userScheme == .dark ? Color.white : Color.black) : Color.clear)
                        .foregroundStyle(isTheItemSelected ? (userScheme == .dark ? Color.black : Color.white) : .black)
                    }
                }
         }
            .scrollIndicators(.hidden)
    }
}

#Preview {
    ContentView()
}
