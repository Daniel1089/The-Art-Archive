//
//  infoCardView.swift
//  The Art Archive
//
//  Created by Daniel on 15/7/26.
//

import SwiftUI
import QuickLook
import UIKit

struct infoCardView: View {
    var card: CardArt
    @Environment(\.colorScheme) var userScheme: ColorScheme
    @State var isDescriptionClicked: Bool = false
    @State var isPhotoClicked: Bool = false
    @State private var mainUrl: URL? = nil
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Binding var isCardTouched: Bool
    var body: some View {
        let layout = horizontalSizeClass == .regular ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
        ScrollView(){
            layout{
                VStack(){
                    HStack(){
                        Button(action: {
                            mainUrl = urlAsset(card.images)
                        }, label: {
                            Image(card.images)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 300)
                                .clipped()
                                .font(.caption)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        })
                        .quickLookPreview($mainUrl)
                    }
                    Spacer()
                }
                VStack{
                    HStack{
                        VStack(alignment: .leading){
                            Text(card.title)
                                .font(.system(size: 30, weight: .heavy, design: .serif))
                                .italic()
                                .foregroundStyle(Color(hex: card.secondaryColor))
                                .lineLimit(3)
                            
                            Text(card.artist)
                                .font(.system(size: 24, weight: .semibold, design: .serif))
                                .foregroundStyle(Color(hex: card.secondaryColor))
                                .lineLimit(10)
                            
                            Text(card.medium)
                                .font(.system(size: 18, weight: .regular, design: .serif))
                                .foregroundStyle(Color(hex: card.secondaryColor))
                                .lineLimit(10)
                            
                            let finalPeriodOfTime = card.periodOfTime != "(There is no available period of time about this specific artwork)" ? card.periodOfTime : ""
                            
                            Text("\(card.culture), \(card.date) \(finalPeriodOfTime)")
                                .font(.system(size: 18, weight: .regular, design: .serif))
                                .foregroundStyle(Color(hex: card.secondaryColor))
                            
                            Text(card.location)
                                .font(.system(size: 18, weight: .regular, design: .serif))
                                .foregroundStyle(Color(hex: card.secondaryColor))
                                .lineLimit(10)
                            
                            Link(destination: card.url, label: {
                                Text("\(card.dataBy) (\(card.numberObject))")
                                    .font(.system(size: 18, weight: .semibold, design: .serif))
                                    .underline()
                                    .foregroundStyle(Color(hex: card.secondaryColor))
                                    .lineLimit(10)
                            })
                        }
                        .padding(.horizontal, 10)
                        Spacer()
                    }
                    
                    HStack{
                        VStack(alignment: .leading){
                            Text(card.description)
                                .font(.system(size: 18, weight: .regular, design: .serif))
                                .foregroundStyle(Color(hex: card.mainColor))
                                .lineLimit(isDescriptionClicked ? .max : 20)
                                .onTapGesture {
                                    isDescriptionClicked.toggle()
                                }
                        }
                        .padding(6)
                        Spacer()
                    }
                    .background(Color(hex: card.secondaryColor))
                    .clipShape(RoundedRectangle(cornerRadius: CGFloat(integerLiteral: 5), style: .continuous))
                    .padding(10)
                    .onAppear(){
                        isCardTouched = true
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

extension View {
    func urlAsset(_ name: String) -> URL? {
        guard let image = UIImage(named: name),
              let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(name).jpg")
        try? data.write(to: url)
        return url
    }
}

#Preview {
    ContentView()
}
