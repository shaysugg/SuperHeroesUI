//
//  SuperHeroSaver.swift
//  SuperHeros
//
//  Created by Sha Yan on 1/11/21.
//

import Foundation
import Combine

protocol SuperHeroStorage {
    func set(_ value: Any?, forKey: String)
    func data(forKey: String) -> Data?
}


class FaveSuperHeroStorage: ObservableObject {
    
    @Published var superHeros = [SuperHero]()
    private var storage: SuperHeroStorage = UserDefaults.standard
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let superHerosKey = "savedSuperHeros"
    static let shared = FaveSuperHeroStorage()
    
    init(storage: SuperHeroStorage? = nil) {
        self.superHeros = loadSavedSuperHeros()
        if let storage = storage {
            self.storage = storage
        }
    }
    
    func save(superHeros: [SuperHero]) throws {
        var loadedSuperHeros = loadSavedSuperHeros()
        loadedSuperHeros.append(contentsOf: superHeros)
        let data = try encoder.encode(loadedSuperHeros)
        storage.set(data, forKey: superHerosKey)
    
        self.superHeros = loadSavedSuperHeros()
    }
    
    func delete(superHeros: [SuperHero]) throws {
        var loadedSuperHeros = loadSavedSuperHeros()
        let superHeroIDs = superHeros.map {$0.id}
        loadedSuperHeros.removeAll { superHeroIDs.contains($0.id)}
        let data = try encoder.encode(loadedSuperHeros)
        storage.set(data, forKey: superHerosKey)
        
        self.superHeros = loadSavedSuperHeros()
    }
    
    private func loadSavedSuperHeros() -> [SuperHero] {
        guard let storageData = storage.data(forKey: superHerosKey) else { return [] }
        guard let loadedSuperHeros = try? decoder.decode([SuperHero].self, from: storageData) else { return [] }
        return loadedSuperHeros
    }
}

// for testing
extension UserDefaults: SuperHeroStorage {}

class MockUserDefaults: SuperHeroStorage {
    
    private var data = Data()
    
    func set(_ value: Any?, forKey: String) {
        if let data = value as? Data {
            self.data = data
        }
    }
    
    func data(forKey: String) -> Data? {
        return data
    }
    
    
}


