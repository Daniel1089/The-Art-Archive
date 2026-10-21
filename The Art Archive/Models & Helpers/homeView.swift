//
//  homeView.swift
//  The Art Archive
//
//  Created by Daniel on 1/10/26.
//

import SwiftUI
private let gildedFrame: String = "gildedFrame"

struct homeView: View {
    var card: CardArt = CardArt(id: 401, title: "Bamboo Shoots", description: "This abbreviated, sketchlike depiction of young bamboo shoots emerging from the earth and the accompanying inscription in cursive script are both the work of Shokusanjin (better known as Ōta Nanpo), a poet and author of fiction. Renowned for his kyōka, or comic verses, Shokusanjin also often collaborated with artists, contributing his own poetry and calligraphy to their paintings or prints.", artist: "Shokusanjin (Ōta Nanpo) (Japanese, 1749–1823)", images: "bambooShoots_1", culture: "Japan", periodOfTime: "Edo period (1615–1868)", date: "1820", location: "The Met Fifth Avenue in Gallery 227", dataBy: "The Met Museum", medium: "Hanging scroll; ink on silk", numberObject: "1975.268.134", url: URL(string: "https://stardance.hackclub.com/projects/22382")!, mainColor: "#B2936B", secondaryColor: "#604125")
    @State private var isOverlaySelected: Bool = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @AppStorage("backgroundColor") var backgroundColor: String = ""

    var body: some View {
        let layout = horizontalSizeClass == .regular ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
        GeometryReader{ proxy in
            layout{
                NavigationStack{
                    ScrollView{
                        HStack(){
                            Text("Artwork of the day")
                                .font(.system(size: 26, weight: .heavy, design: .monospaced))
                                .foregroundStyle(Color(hex: card.mainColor))
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 18, weight: .bold, design: .monospaced))
                                .foregroundStyle(Color(hex: card.mainColor))
                        }
                        .onTapGesture {
                            withAnimation{
                                isOverlaySelected.toggle()
                            }
                        }
                        .padding(10)
                        .background(Color(hex: card.secondaryColor))
                        .clipShape(RoundedRectangle(cornerRadius: CGFloat(integerLiteral: 20), style: .continuous))
                        HStack{
                            Text(Date.now, format: .dateTime.day().month(.wide).year())
                                .font(.system(size: 28, weight: .regular, design: .serif))
                                .foregroundStyle(Color(hex: card.secondaryColor))
                        }
                        VStack{
                            Image(card.images)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: (proxy.size.width / 100) * 80, maxHeight: (proxy.size.height / 100) * 75)
                                .clipped()
                                .font(.caption)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .padding(10)
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
                            
                            HStack{
                                VStack(alignment: .leading){
                                    Text(card.description)
                                        .font(.system(size: 18, weight: .regular, design: .serif))
                                        .foregroundStyle(Color(hex: card.mainColor))
                                        .padding(6)
                                    Spacer()
                                }
                                .background(Color(hex: card.secondaryColor))
                                .clipShape(RoundedRectangle(cornerRadius: CGFloat(integerLiteral: 5), style: .continuous))
                            }
                        }
                        .safeAreaPadding(.horizontal, 10)
                    }
                    .frame(maxWidth: proxy.size.width, maxHeight: proxy.size.height)
                    .scrollTargetBehavior(.paging)
                    .background(Color(hex: card.mainColor)).opacity(0.75)
                    .scrollIndicators(.hidden)
                }
                .onAppear(){
                    backgroundColor = card.mainColor
                }
                .overlay(alignment: .bottom, content: {
                    if isOverlaySelected{
                        VStack{
                            changeCardView(viewImage: "photo.artframe", viewName: "Artwork of the day", viewMainColor: card.secondaryColor)
                                .background(Color(hex: card.mainColor))
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .frame(maxWidth: proxy.size.width * 0.95)
                                .transition(.scale)
                            
                            changeCardView(viewImage: "mail.stack", viewName: "Previously seen artworks", viewMainColor: card.secondaryColor)
                                .background(Color(hex: card.mainColor))
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .frame(maxWidth: proxy.size.width * 0.95)
                        }
                        .padding(5)
                        .background(Color(hex: card.secondaryColor))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .padding(.horizontal, 5)
                    }
                })
            }
            .frame(maxWidth: proxy.size.width, maxHeight: proxy.size.height)
        }
    }
}

struct changeCardView: View {
    var viewImage: String
    var viewName: String
    var viewMainColor: String
    var body: some View {
        HStack{
            Image(systemName: viewImage)
                .foregroundStyle(Color(hex: viewMainColor))
                .font(.system(size: 18, weight: .semibold, design: .monospaced))
            Text(viewName)
                .foregroundStyle(Color(hex: viewMainColor))
                .font(.system(size: 18, weight: .semibold, design: .monospaced))
            Spacer()
        }
        .padding()
    }
}

struct sortModel {
    var allArtworksId: [Int]
    var alreadySeenArtworks: Set<Int>
    var result: Int { (allArtworksId.filter { alreadySeenArtworks.contains($0) }).randomElement() ?? 1 }
    
}

#Preview {
    ContentView()
}
