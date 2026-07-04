//
//  TabBar.swift
//  MyApp
//
//  Created by Daniel on 22/6/26.
//

import Foundation
import SwiftUI

struct TabBar: View {
    var items: [String]
    var searchHint: String = "What piece of art are you looking for?"
    @Binding var selection: String
    @Binding var searchText: String
    @Binding var isSearchExpanded: Bool
    var onSearchActivated: (Bool) -> ()
    @Environment(\.colorScheme) private var colorScheme
    @State private var viewSize: CGSize = .zero
    @FocusState private var isKeyboardActivate: Bool
    private let mainAnimation: Animation = .interpolatingSpring(duration: 0.3, bounce: 0, initialVelocity: 0)
    
    
    var body: some View {
        ScrollView(.horizontal){
            HStack(spacing: 12) {
                ForEach(items, id: \.self){ item in
                    ItemView(item)
                }
                searchBar()
            }
            .padding(.horizontal, 15)
            .visualEffect { [isSearchExpanded, viewSize] content, proxy in
                let rect = proxy.frame(in: .scrollView)
                let maxX = rect.maxX - viewSize.width
                
                return content
                    .offset(x: isSearchExpanded ? -maxX : 0)
            }
        }
        .frame(height: 50)
        .scrollDisabled(isSearchExpanded)
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .animation(mainAnimation, value: selection)
        .animation(mainAnimation, value: isKeyboardActivate)
        .onChange(of: isKeyboardActivate){ oldValue, newValue in
            onSearchActivated(newValue)
        }
        .onGeometryChange(for: CGSize.self){
            $0.size
        } action: { newValue in
            viewSize = newValue
        }
    }
    
    //View used for the predefined categories
    @ViewBuilder
    private func ItemView(_ item: String) -> some View {
        let isSelected = selection == item
        let foregroundTint: Color = isSelected ? (colorScheme != .dark ? .white : .black) : .primary
        let backgroundTint: Color = isSelected ? (colorScheme == .dark ? .white : .black) : .clear
        let isLast = items.last == item && isSearchExpanded
        
        ZStack {
            if isLast {
                Image(systemName: "circle.grid.2x2.fill")
                    .frame(width: 60, height: 45)
                    .glassEffect(.regular.interactive(), in: .capsule)
                    .contentShape(.capsule)
                    .onTapGesture {
                        isKeyboardActivate = false
                        withAnimation(mainAnimation){
                            isSearchExpanded = false
                        }
                    }
                    .padding(.leading, 12)
            } else {
                Text(item)
                    .padding(.horizontal, 15)
                    .frame(height: 45)
                    .foregroundStyle(foregroundTint)
                    .background(backgroundTint, in: .capsule)
                    .glassEffect(.regular.interactive(!isSearchExpanded), in: .capsule)
                    .contentShape(.capsule)
                    .onTapGesture {
                        selection = item
                    }
                    .disabled(isSearchExpanded)
            }
        }
    }
    
    
    //View used for the search button
    @ViewBuilder
    private func searchBar() -> some View {
        let fitSearchBar: CGFloat = viewSize.width - 102
        
        ZStack(alignment: .trailing){
            HStack(spacing: 0){
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                    .frame(width: isSearchExpanded ? 40 : 60)
                
                if isSearchExpanded {
                    TextField(searchHint, text: $searchText)
                        .focused($isKeyboardActivate)
                }
            }
            .padding(.leading, isSearchExpanded ? 5 : 0)
            .padding(.trailing, isSearchExpanded ? 15 : 0)
            .frame(height: 45)
            .clipShape(.capsule)
            .glassEffect(.regular.interactive(), in: .capsule)
            .contentShape(.capsule)
            .gesture(TapGesture(count: 1).onEnded { _ in
                withAnimation(mainAnimation){ isSearchExpanded = true }
            }, isEnabled: !isSearchExpanded)
            .zIndex(1)
            .padding(.trailing, isKeyboardActivate ? 57 : 0)
            
            Image(systemName: "xmark")
                .frame(width: 45, height: 45)
                .glassEffect(.regular.interactive(), in: .circle)
                .contentShape(.circle)
                .onTapGesture {
                    isKeyboardActivate = false
                }
                .opacity(isKeyboardActivate ? 1 : 0)
                .offset(x: isKeyboardActivate ? 0 : 70)
                .zIndex(0)
        }
        .frame(width: isSearchExpanded ? fitSearchBar : nil)
    }
}
