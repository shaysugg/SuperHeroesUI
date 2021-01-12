//
//  SuperHeroMockData.swift
//  SuperHeros
//
//  Created by Sha Yan on 1/12/21.
//

import Foundation

extension Array where Element == SuperHero {
    static func createMockData() -> [SuperHero] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let url = Bundle.main.url(forResource: "SuperHerosEx", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Error: not a valid json file to create mock data")
            return []
        }
        
        let superHeros = try? decoder.decode([SuperHero].self, from: data)
        return superHeros ?? []
    }
}
