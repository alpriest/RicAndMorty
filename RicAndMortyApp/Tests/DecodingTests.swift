//
//  DecodingTests.swift
//  RicAndMortyTests
//
//  Created by Alistair Priest on 05/03/2022.
//

import XCTest
@testable import RicAndMorty

class DecodingTests: XCTestCase {
    func test_decodesGarbageStatusAsUnknown() throws {
        guard let url = Bundle(for: DecodingTests.self).url(forResource: "garbage_status", withExtension: ".json") else {
            XCTFail()
            return
        }

        let data = try Data(contentsOf: url)

        let result = try JSONDecoder().decode(CharacterBlueprint.self, from: data)

        XCTAssertEqual(result.status, .unknown)
    }

    func test_decodesInvalidStatusTypeAsUnknown() throws {
        guard let url = Bundle(for: DecodingTests.self).url(forResource: "wrong_type_status", withExtension: ".json") else {
            XCTFail()
            return
        }

        let data = try Data(contentsOf: url)

        let result = try JSONDecoder().decode(CharacterBlueprint.self, from: data)

        XCTAssertEqual(result.status, .unknown)
    }

    func test_decodesValidFormat() throws {
        guard let url = Bundle(for: DecodingTests.self).url(forResource: "valid_status", withExtension: ".json") else {
            XCTFail()
            return
        }

        let data = try Data(contentsOf: url)

        let result = try JSONDecoder().decode(CharacterBlueprint.self, from: data)

        let expected = CharacterBlueprint(
            id: 361,
            name: "Toxic Rick",
            status: .alive,
            species: "Humanoid",
            image: "https://rickandmortyapi.com/api/character/avatar/361.jpeg",
            location: LocationBlueprint(name: "Earth"))

        XCTAssertEqual(result, expected)
    }
}
