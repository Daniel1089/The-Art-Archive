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
    @AppStorage("isCardTouched") var isCardTouched: Bool = false
    
    var body: some View {
            NavigationLink(destination:  infoCardView(card: card, isDescriptionClicked: false, isPhotoClicked: false), label: {
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
            })
            .padding(4)
            .background(Color(hex: card.mainColor))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .onTapGesture {
                isInfoRequired = true
            }
            .onChange(of: isInfoRequired){
                if !isInfoRequired {
                    isCardTouched = false
                }
            }
            }
        }
       

#Preview {
    ContentView()
}
