//
//  CardStackView.swift
//  The Art Archive
//
//  Created by Daniel on 28/6/26.
//

import SwiftUI
import DominantColor

struct CardStackView: View {
    @State private var cards: [CardArt] = []
    @State private var errorMessage: String?
    
    var body: some View {
        Group {
            if let errorMessage {
                Text(errorMessage).foregroundStyle(.red)
            } else if cards.isEmpty {
                ProgressView("Loading cards…")
            } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                        ForEach(cards) { card in
                            CardView(card: card)
                                .padding(.horizontal)
                                .frame(height: 220)
                        }
                    }
                }
            }
        }
        .task {
            await loadCards()
        }
    }
    
        @MainActor
        private func loadCards() async {
            do {
                let loaded = try CardArt(id: 0, title: "", description: "", images: "", culture: "", periodOfTime: "", date: "", location: "", dataBy: "", medium: "", numberObject: "", url: URL(string: "https://www.apple.com")!)
                    .loadCardsFromBundle(named: "artCards")
                self.cards = loaded
            } catch {
                self.errorMessage = "Failed to load artCards.json: \(error.localizedDescription)"
            }
        }
    }


#Preview {
    CardStackView()
}

