//
//  SuperHerosTests.swift
//  SuperHerosTests
//
//  Created by Sha Yan on 1/11/21.
//

import XCTest

@testable import SuperHeros

class SuperHerosSaverTests: XCTestCase {

    var storage: FaveSuperHeroStorage!
    var mockSuperHeros: [SuperHero]!
    
    override func setUpWithError() throws {
        storage = FaveSuperHeroStorage(storage: MockUserDefaults())
        mockSuperHeros = [SuperHero].createMockData()
    }

    override func tearDownWithError() throws {
        storage = nil
    }

    func testSave() throws {
        try storage.save(superHeros: mockSuperHeros)
        XCTAssertEqual(storage.superHeros.first?.name, mockSuperHeros.first?.name)
        XCTAssertEqual(storage.superHeros.count, mockSuperHeros.count)
    }
    
    func testRemove() throws {
        try storage.save(superHeros: mockSuperHeros)
        try storage.delete(superHeros: [mockSuperHeros.first!])
        XCTAssertFalse(storage.superHeros.contains(where: {$0.id == mockSuperHeros.first?.id}))
        XCTAssertEqual(storage.superHeros.count, mockSuperHeros.count - 1)
    }

}
