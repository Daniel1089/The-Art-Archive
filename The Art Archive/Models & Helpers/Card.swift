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
    var images: String
    var culture: String
    var periodOfTime: String
    var date: String
    var location: String
    var dataBy: String
    var medium: String
    var numberObject: String
    var url: URLComponents
    
    enum codingKeys: String, CodingKey {
        case id
        case title
        case description
        case images
        case culture
        case periodOfTime
        case date
        case location
        case dataBy
        case medium
        case numberObject
        case url
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
