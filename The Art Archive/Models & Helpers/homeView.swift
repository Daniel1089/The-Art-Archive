//
//  homeView.swift
//  The Art Archive
//
//  Created by Daniel on 1/10/26.
//

import SwiftUI
import QuickLook
private let gildedFrame: String = "gildedFrame"

struct homeView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var mainUrl: URL? = nil
    @State private var card: CardArt? = nil
    @State private var seenIDs: Set<Int> = []
    @State private var loadError: String? = nil
    private let selectedDateKey = "dailySelectedDate"
    private let selectedArtIDKey = "dailySelectedArtID"
    private let seenIDsKey = "seenArtIDs"
    private let selectedArtDataKey = "dailySelectedArtData"

    var body: some View {
        NavigationStack{
            GeometryReader{ proxy in
                if let card = card {
                    ScrollView{
                        HStack(){
                            Text("Artwork of the day")
                                .font(.system(size: 26, weight: .heavy, design: .monospaced))
                                .foregroundStyle(Color(hex: card.mainColor))
                        }
                        .padding(10)
                        .background(Color(hex: card.secondaryColor))
                        .clipShape(RoundedRectangle(cornerRadius: CGFloat(integerLiteral: 20), style: .continuous))
                        HStack{
                            Text(Date.now, format: .dateTime.day().month(.wide).year())
                                .font(.system(size: 28, weight: .regular, design: .serif))
                                .foregroundStyle(Color(hex: card.secondaryColor))
                        }
                        let layout = horizontalSizeClass == .regular ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
                        layout{
                            VStack{
                                Button(action: {
                                    mainUrl = urlAsset(card.images)
                                }, label: {
                                    Image(card.images)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: (proxy.size.width / 100) * 80, maxHeight:
                                                horizontalSizeClass == .regular ?
                                               (proxy.size.height / 100 * 120) : (proxy.size.height / 100 * 75))
                                        .clipped()
                                        .font(.caption)
                                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                })
                            }
                            .quickLookPreview($mainUrl)
                            .padding(10)
                            
                            VStack(alignment: .leading){
                                Text(card.title)
                                    .font(.system(size: 30, weight: .heavy, design: .serif))
                                    .italic()
                                    .foregroundStyle(Color(hex: card.secondaryColor))
                                
                                Text(card.artist)
                                    .font(.system(size: 24, weight: .semibold, design: .serif))
                                    .foregroundStyle(Color(hex: card.secondaryColor))
                                
                                Text(card.medium)
                                    .font(.system(size: 18, weight: .regular, design: .serif))
                                    .foregroundStyle(Color(hex: card.secondaryColor))
                                
                                let finalPeriodOfTime = card.periodOfTime != "(There is no available period of time about this specific artwork)" ? card.periodOfTime : ""
                                
                                Text("\(card.culture), \(card.date) \(finalPeriodOfTime)")
                                    .font(.system(size: 18, weight: .regular, design: .serif))
                                    .foregroundStyle(Color(hex: card.secondaryColor))
                                
                                Text(card.location)
                                    .font(.system(size: 18, weight: .regular, design: .serif))
                                    .foregroundStyle(Color(hex: card.secondaryColor))
                                
                                Link(destination: card.url, label: {
                                    Text("\(card.dataBy) (\(card.numberObject))")
                                        .font(.system(size: 18, weight: .semibold, design: .serif))
                                        .underline()
                                        .foregroundStyle(Color(hex: card.secondaryColor))
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
                    }
                    .frame(maxWidth: proxy.size.width, maxHeight: proxy.size.height)
                    .scrollTargetBehavior(.paging)
                    .background(Color(hex: card.mainColor)).opacity(0.75)
                    .scrollIndicators(.hidden)
                } else {
                    VStack(spacing: 16) {
                        if let loadError {
                            Image(systemName: "exclamationmark.triangle.fill").font(.largeTitle)
                            Text("No se pudo cargar la obra del día")
                                .font(.headline)
                            Text(loadError)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            Button("Reintentar") { loadPersistedStateFast() }
                                .buttonStyle(.borderedProminent)
                        } else {
                            ProgressView("Cargando obra del día…")
                            Text("Preparando la obra de arte de hoy")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .onAppear { loadPersistedStateFast() }
    }

    private func loadAllArtworks() -> [CardArt] {
        do {
            let loader = CardArt(id: 0, title: "", description: "", artist: "", images: "", culture: "", periodOfTime: "", date: "", location: "", dataBy: "", medium: "", numberObject: "", url: URL(string: "https://apple.com")!, mainColor: "#B2936B", secondaryColor: "#604125")
            let items = try loader.loadCardsFromBundle(named: "artCards")
            return items
        } catch {
            return []
        }
    }

    private func loadPersistedStateFast() {
        loadError = nil
        let defaults = UserDefaults.standard
        if let seenArray = defaults.array(forKey: seenIDsKey) as? [Int] {
            seenIDs = Set(seenArray)
        }
        if let date = defaults.object(forKey: selectedDateKey) as? Date,
           Calendar.current.isDateInToday(date),
           let data = defaults.data(forKey: selectedArtDataKey),
           let decoded = try? JSONDecoder().decode(CardArt.self, from: data) {
            self.card = decoded
            return
        }
        Task.detached { [seenIDs] in
            let all = await loadAllArtworks()
            guard !all.isEmpty else {
                await MainActor.run { self.loadError = "artCards.json no encontrado o vacío" }
                return
            }
            var localSeen = seenIDs
            var remaining = all.map { $0.id }.filter { !localSeen.contains($0) }
            if remaining.isEmpty { localSeen.removeAll(); remaining = all.map { $0.id } }
            guard let chosenID = remaining.randomElement(), let found = all.first(where: { $0.id == chosenID }) else {
                await MainActor.run { self.loadError = "No se pudo seleccionar una obra" }
                return
            }
            var newSeen = localSeen
            newSeen.insert(chosenID)
            await MainActor.run {
                self.card = found
                self.seenIDs = newSeen
                persistSelection(chosen: found, chosenID: chosenID)
            }
        }
    }

    private func persistSelection(chosen: CardArt, chosenID: Int) {
        let defaults = UserDefaults.standard
        defaults.set(Calendar.current.startOfDay(for: Date()), forKey: selectedDateKey)
        defaults.set(chosenID, forKey: selectedArtIDKey)
        defaults.set(Array(seenIDs), forKey: seenIDsKey)
        if let data = try? JSONEncoder().encode(chosen) {
            defaults.set(data, forKey: selectedArtDataKey)
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

