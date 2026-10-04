//
//  CardStackView.swift
//  The Art Archive
//
//  Created by Daniel on 28/6/26.
//

import SwiftUI

struct CardStackView: View {
    @State private var cards: [CardArt] = []
    @State private var errorMessage: String?
    let columsArrangement: [GridItem] = [GridItem(.adaptive(minimum: 120))]
    @State private var searchText: String = ""
    @State private var itemCategories: [String] = ["All", "Roman", "British", "Italian", "French", "Chinese", "American", "Japan", "Greek, Attic"]
    @State private var selection: String = "All"
    @State private var isCardTouched: Bool = false
    @State private var isPortrait: Bool = false
    @State private var isLandscape: Bool = false
    @State private var futureWidth: CGFloat = CGFloat(integerLiteral: 0)
    @State private var futureHeight: CGFloat = CGFloat(integerLiteral: 0)
    
    var filteredCards: [CardArt] {
        cards.filter { card in
            let matchesCulture = (selection == "All") || (card.culture == selection)
            let matchesSearch = searchText.isEmpty || card.title.localizedCaseInsensitiveContains(searchText)
            return matchesCulture && matchesSearch
        }
    }
    
    var body: some View {
        GeometryReader{ proxy in
            let realWidth = proxy.size.width
            let realHeight = proxy.size.height
            
                NavigationStack{
                    Group {
                        if let errorMessage {
                            Text(errorMessage).foregroundStyle(.red)
                        } else if cards.isEmpty {
                            ProgressView("Loading cards…")
                        } else {
                            ScrollView {
                                HStack{
                                    segmentedBar(items: $itemCategories, selection: $selection)
                                        .safeAreaPadding(.vertical, 5)
                                        .safeAreaPadding(.horizontal, 12)
                                }
                                if isPortrait {
                                    HStack(alignment: .top){
                                        LazyVStack(){
                                            ForEach(filteredCards.indices.filter({ $0.isMultiple(of: 2)}), id: \.self){ index in
                                                CardView(card: filteredCards[index], isCardTouched: $isCardTouched)
                                            }
                                        }
                                        
                                        LazyVStack(){
                                            ForEach(filteredCards.indices.filter({ !$0.isMultiple(of: 2)}), id: \.self){ index in
                                                CardView(card: filteredCards[index], isCardTouched: $isCardTouched)
                                            }
                                        }
                                    }
                                    .safeAreaPadding(.horizontal, 10)
                                }
                                if !isPortrait {
                                    HStack(alignment: .top){
                                        LazyVStack(){
                                            ForEach(filteredCards.indices.filter({
                                                $0 % 4 == 0}), id: \.self){ index in
                                                    CardView(card: filteredCards[index], isCardTouched: $isCardTouched)
                                                }
                                        }
                                        
                                        LazyVStack(){
                                            ForEach(filteredCards.indices.filter({ $0 % 4 == 1}), id: \.self){ index in
                                                CardView(card: filteredCards[index], isCardTouched: $isCardTouched)
                                            }
                                        }
                                        
                                        LazyVStack(){
                                            ForEach(filteredCards.indices.filter({ $0 % 4 == 2}), id: \.self){ index in
                                                CardView(card: filteredCards[index], isCardTouched: $isCardTouched)
                                            }
                                        }
                                        
                                        LazyVStack(){
                                            ForEach(filteredCards.indices.filter({ $0 % 4 == 3}), id: \.self){ index in
                                                CardView(card: filteredCards[index], isCardTouched: $isCardTouched)
                                            }
                                        }
                                    }
                                    .safeAreaPadding(.horizontal, 10)
                                }
                            }
                            .scrollIndicators(.hidden)
                        }
                    }
                }
                .navigationTitle(realWidth < realHeight ? "Archive" : "")
                .searchable(text: $searchText, placement: realWidth < realHeight ? .navigationBarDrawer(displayMode: .always) : .toolbar)
                .searchToolbarBehavior(.minimize)
                .task {
                    await loadCards()
                }
                .onAppear(){
                    if realWidth > realHeight && !isCardTouched{
                        isPortrait = false
                    } else if realWidth < realHeight && !isCardTouched {
                        isPortrait = true
                    }
                }
                .onChange(of: realWidth){
                    if realWidth > realHeight && !isCardTouched{
                        isPortrait = false
                    } else if realWidth < realHeight && !isCardTouched {
                        isPortrait = true
                    } else if isCardTouched {
                        futureWidth = realWidth
                        futureHeight = realHeight
                    }
                }
                .onChange(of: isCardTouched){
                    if !isCardTouched{
                        if futureWidth > futureHeight {
                            isPortrait = false
                        } else if futureWidth < futureHeight {
                            isPortrait = true
                        }
                    }
                }
        }
        }
    
        @MainActor
        private func loadCards() async {
            do {
                let loaded = try CardArt(id: 0, title: "", description: "", artist: "", images: "", culture: "", periodOfTime: "", date: "", location: "", dataBy: "", medium: "", numberObject: "", url: URL(string: "https://www.apple.com")!, mainColor: "", secondaryColor: "")
                    .loadCardsFromBundle(named: "artCards")
                self.cards = loaded
            } catch {
                self.errorMessage = "Failed to load artCards.json: \(error.localizedDescription)"
            }
        }
    }


#Preview {
    ContentView()
}

