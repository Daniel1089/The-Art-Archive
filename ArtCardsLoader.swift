import Foundation

struct ArtCard: Codable, Identifiable {
    let id: Int
    let title: String
    let artist: String?
    let year: String?
}

func loadArtCards() -> [ArtCard] {
    guard let url = Bundle.main.url(forResource: "artcards", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let decoded = try? JSONDecoder().decode([ArtCard].self, from: data) else {
        print("Error: no se pudo cargar el archivo JSON o decodificarlo")
        return []
    }
    
    let cleaned = decoded.map { card -> ArtCard in
        ArtCard(id: card.id,
                title: card.title.trimmingCharacters(in: .whitespacesAndNewlines),
                artist: card.artist?.trimmingCharacters(in: .whitespacesAndNewlines),
                year: card.year?.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    let nonEmpty = cleaned.filter { !$0.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    
    if nonEmpty.count != cleaned.count {
        print("ADVERTENCIA: Se ignoraron \(cleaned.count - nonEmpty.count) tarjetas vacías del JSON.")
    }
    
    for card in nonEmpty {
        let duplicates = nonEmpty.filter { $0.title == card.title }
        if duplicates.count > 1 {
            print("ADVERTENCIA: Hay \(duplicates.count) tarjetas con el título '\(card.title)'.")
        }
    }
    
    return nonEmpty
}
