//
//  infoCardView.swift
//  The Art Archive
//
//  Created by Daniel on 15/7/26.
//

import SwiftUI

struct infoCardView: View {
    let card: CardArt
    @Environment(\.colorScheme) var userScheme: ColorScheme
    
    var body: some View {
        GeometryReader(){ geometry in
            ScrollView(){
                HStack(){
                    Image(card.images)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 250)
                        .clipped()
                        .font(.caption)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                
                VStack(alignment: .leading){
                    Text(card.title)
                        .font(.system(size: 30, weight: .semibold, design: .serif))
                        .foregroundStyle(Color(hex: card.mainColor))
                        .lineLimit(3)
                        .padding(.horizontal, 4)
                        .padding(.top, 2)
                    
                    Text("\(card.culture), \(card.date) (\(card.periodOfTime))")
                        .font(.system(size: 26, weight: .medium, design: .serif))
                        .foregroundStyle(Color(hex: card.mainColor))
                        .padding(.bottom, 4)
                    
                    Text(card.description)
                        .font(.system(size: 18, weight: .regular, design: .serif))
                        .foregroundStyle(Color(hex: card.mainColor))
                        .lineLimit(10)
                
                    Text(card.location)
                    
                    Text(card.medium)
                    
                    Text(card.numberObject)
                }
                .background(Color.white)
                .padding(.horizontal, 10)
            }
            .scrollIndicators(.hidden)
            .presentationBackground(Color(hex: card.mainColor).opacity(0.75))
        }
    }
}

#Preview {
    CardStackView()
}
