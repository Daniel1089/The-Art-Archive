//
//  CardView.swift
//  The Art Archive
//
//  Created by Daniel on 28/6/26.
//

import SwiftUI
import DominantColor

struct CardView: View {
    let card: CardArt
    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                Image(card.images)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 180, height: 220)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(5)
                    
            VStack(alignment: .leading) {
                Text(card.title)
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .foregroundStyle(Color.black)
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                
                Spacer()
                Text(card.culture)
                    .font(.system(size: 20, weight: .regular, design: .monospaced))
                
                Text(card.date)
                    .font(.system(size: 16, weight: .none, design: .monospaced))
                    .foregroundStyle(Color.secondary)
                
            }
            .padding(.vertical, 10)
            Spacer()
        }
        .background(Color.cyan)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
        }
       

#Preview {
    CardStackView()
}

