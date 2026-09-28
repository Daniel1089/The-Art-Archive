//
//  CardView.swift
//  The Art Archive
//
//  Created by Daniel on 28/6/26.
//

import SwiftUI

struct CardView: View {
    let card: CardArt
    @State private var isInfoRequired: Bool = false
    
    var body: some View {
            VStack(alignment: .leading) {
                Image(card.images)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 400)
                    .clipped()
                    .font(.caption)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(5)
        .onTapGesture {
            isInfoRequired.toggle()
        }
        .sheet(isPresented: $isInfoRequired){
            infoCardView(card: card)
                .safeAreaPadding(.top, 20)
                .safeAreaPadding(.horizontal, 10)
                .presentationDetents([.medium, .large])
        }
        .background(Color(hex: card.mainColor))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
        }
       

#Preview {
    CardStackView()
}

