//
//  SuperHero.swift
//  SuperHeros
//
//  Created by Sha Yan on 10/3/20.
//

import Foundation
import Combine

struct SuperHero: Codable, Identifiable {
    let id: String
    let name: String
    let powerstats: PowerStats
    let biography: Biography
    let appearance: Appearance
    let image: HeroImage
    let work: Work
    let connections: Connections
    
}


struct PowerStats: Codable {
    let intelligence: String?
    let strength: String?
    let speed: String?
    let power: String?
    let combat: String?
}


struct Biography: Codable {
    enum CodingKeys: String, CodingKey {
        case alignment
        case fullname = "full-name"
        case firstAppearance = "first-appearance"
    }
    
    let fullname: String
    let firstAppearance: String
    let alignment: String
}


struct Appearance: Codable {
    let gender: String
    let height: [String]
    let weight: [String]
}

struct Connections: Codable {
    let relatives: String
}

struct Work: Codable {
    let base: String
}

struct HeroImage: Codable {
    let url: String
}


