//
//  Card.swift
//  The Art Archive
//
//  Created by Daniel on 28/6/26.
//

import Foundation
import SwiftUI

struct CardArt: Identifiable, Codable {
    let id: Int
    var title: String
    var description: String
    var artist: String
    var images: String
    var culture: String
    var periodOfTime: String
    var date: String
    var location: String
    var dataBy: String
    var medium: String
    var numberObject: String
    var url: URL
    var mainColor: String
    var secondaryColor: String
    
    enum codingKeys: String, CodingKey {
        case id
        case title
        case description
        case artist
        case images
        case culture
        case periodOfTime
        case date
        case location
        case dataBy
        case medium
        case numberObject
        case url
        case mainColor
        case secondaryColor
    }
    
    func loadCardsFromBundle(named fileName: String = "artCards") throws -> [CardArt] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json")
        else {
            throw NSError(domain: "JSON", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing \(fileName).json in bundle"])
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([CardArt].self, from: data)
    }
}

extension Color {
    init(hex: String){
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b: UInt64
        switch hex.count {
        case 3:
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (200, 200, 200)
        }
        
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}
