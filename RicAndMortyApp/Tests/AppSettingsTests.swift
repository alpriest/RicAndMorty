//
//  AppSettingsTests.swift
//  RicAndMortyTests
//
//  Created by Alistair Priest on 05/03/2022.
//

import XCTest
@testable import RicAndMorty

class AppSettingsTests: XCTestCase {

    func test_findsHostNameFromDictionary() {
        let hostname = "http://server.com"
        let sut = makeSUT(["API_HOST":hostname])

        XCTAssertEqual(try sut.hostName(), hostname)
    }

    func test_throwsWhenKeyNotFound() {
        let sut = makeSUT([:])

        XCTAssertThrowsError(try sut.hostName()) {
            XCTAssert($0 is AppSettings.MissingKeyError)
        }
    }
}

private extension AppSettingsTests {
    func makeSUT(_ dictionary: [String: Any]) -> AppSettings {
        AppSettings(dictionary: dictionary)
    }
}
