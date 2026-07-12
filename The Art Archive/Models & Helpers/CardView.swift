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
            VStack(alignment: .trailing) {
                Image(card.images)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 160, height: 200)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(10)
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text(card.title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.black)
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                
                Spacer()
                Text(card.culture)
                    .font(.system(size: 20, weight: .regular, design: .none))
                
                Text(card.date)
                    .font(.system(size: 20, weight: .none, design: .none))
                    .foregroundStyle(Color.secondary)
                
            }
            .padding(.trailing, 10)
            .padding(.vertical, 10)
        }
    }
        }
       

#Preview {
    CardStackView()
}

