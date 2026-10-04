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
    @Binding var isCardTouched: Bool
    
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
                
                Text(card.title)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(hex: card.secondaryColor))
                
                Text(card.artist)
                    .font(.callout)
                    .fontWeight(.regular)
                    .foregroundStyle(Color(hex: card.secondaryColor))
            }
            .padding(5)
        .onTapGesture {
            isInfoRequired.toggle()
        }
        .onChange(of: isInfoRequired){
            if !isInfoRequired {
                isCardTouched = false
            }
        }
        .sheet(isPresented: $isInfoRequired){
            infoCardView(card: card, isDescriptionClicked: false, isPhotoClicked: false, isCardTouched: $isCardTouched)
                .id(card.title + "::" + card.artist)
                .background(Color(hex: card.mainColor).opacity(0.75))
                .safeAreaPadding(.top, 20)
                .safeAreaPadding(.horizontal, 10)
                .presentationDetents([.large])
        }
        .background(Color(hex: card.mainColor))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
        }
       

#Preview {
    ContentView()
}
