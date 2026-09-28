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
    var filteredCards: [CardArt]{
        if searchText.isEmpty {
            return cards
        } else {
            return cards.filter { $0.title.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    var body: some View {
        NavigationStack{
            Group {
                if let errorMessage {
                    Text(errorMessage).foregroundStyle(.red)
                } else if cards.isEmpty {
                    ProgressView("Loading cards…")
                } else {
                    ScrollView {
                        HStack(alignment: .top){
                            VStack(spacing: 16){
                                ForEach(filteredCards.indices.filter({ $0.isMultiple(of: 2)}), id: \.self){ index in
                                    CardView(card: filteredCards[index])
                                        .onTapGesture(){
                                            
                                        }
                                }
                            }
                            
                            VStack(spacing: 16){
                                ForEach(filteredCards.indices.filter({ !$0.isMultiple(of: 2)}), id: \.self){ index in
                                    CardView(card: filteredCards[index])
                                        .onTapGesture(){
                                            
                                        }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Archive")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .task {
                await loadCards()
            }
        }
        }
    
        @MainActor
        private func loadCards() async {
            do {
                let loaded = try CardArt(id: 0, title: "", description: "", artist: "", images: "", culture: "", periodOfTime: "", date: "", location: "", dataBy: "", medium: "", numberObject: "", url: URL(string: "https://www.apple.com")!, mainColor: "")
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

