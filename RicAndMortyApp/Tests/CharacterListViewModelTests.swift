//
//  CharacterListViewModelTests.swift
//  RicAndMortyTests
//
//  Created by Alistair Priest on 04/03/2022.
//

import XCTest
@testable import RicAndMorty
import Combine

class CharacterListViewModelTests: XCTestCase {

    func test_fetchesResults() {
        let sut = CharacterListViewModel(fetcher: { _ in self.makeSuccessFetcher() })

        sut.fetch()

        XCTAssertEqual(sut.characters.count, 3)
        XCTAssertEqual(sut.characters[0].id, 1)
        XCTAssertEqual(sut.characters[1].id, 2)
        XCTAssertEqual(sut.characters[2].id, 3)
    }

    func test_displaysErrorWhenFetchFails() {
        let sut = CharacterListViewModel(fetcher: { _ in self.makeFailingFetcher() })

        sut.fetch()

        XCTAssertEqual(sut.error, "Could not load. Please check your connection.")
    }

    func test_doesNotFetchWhenNoSubsequentPage() {
        let successfetcher = self.makeSuccessFetcher(startID: 1)
        var fetchCount = 0

        let fetcher = { (url: URL) -> Fetcher in
            fetchCount += 1

            return successfetcher
        }
        let sut = CharacterListViewModel(fetcher: fetcher)

        sut.fetch()
        sut.fetch()

        XCTAssertEqual(fetchCount, 1)
    }

    func test_canLoadNextPageAfterRequest() {
        let page2URL = URL(string: "https://server.com/1")!
        let page1fetcher = self.makeSuccessFetcher(startID: 1, nextPageURL: page2URL)
        let page2fetcher = self.makeSuccessFetcher(startID: 4)

        let paginatedFetcher = { (url: URL) -> Fetcher in
            if url == page2URL {
                return page2fetcher
            }

            return page1fetcher
        }
        let sut = CharacterListViewModel(fetcher: paginatedFetcher)

        sut.fetch()

        XCTAssertEqual(sut.characters.count, 3)
        XCTAssertEqual(sut.characters[0].id, 1)
        XCTAssertEqual(sut.characters[1].id, 2)
        XCTAssertEqual(sut.characters[2].id, 3)

        sut.fetch()

        XCTAssertEqual(sut.characters.count, 6)
        XCTAssertEqual(sut.characters[0].id, 1)
        XCTAssertEqual(sut.characters[1].id, 2)
        XCTAssertEqual(sut.characters[2].id, 3)
        XCTAssertEqual(sut.characters[3].id, 4)
        XCTAssertEqual(sut.characters[4].id, 5)
        XCTAssertEqual(sut.characters[5].id, 6)
    }

    func test_clearsErrorAfterSuccessfulRetry() {
        let failingFetcher = self.makeFailingFetcher()
        let successfetcher = self.makeSuccessFetcher(startID: 1)
        var fetchCount = 0

        let fetcher = { (url: URL) -> Fetcher in
            fetchCount += 1

            if fetchCount == 1 {
                return failingFetcher
            } else {
                return successfetcher
            }
        }
        let sut = CharacterListViewModel(fetcher: fetcher)

        sut.fetch()

        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.characters.count, 0)

        sut.fetch()

        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.characters.count, 3)
        XCTAssertEqual(sut.characters[0].id, 1)
        XCTAssertEqual(sut.characters[1].id, 2)
        XCTAssertEqual(sut.characters[2].id, 3)
    }

    func test_doesNotFetchWhenFirstCharacterAppears() {
        let page2URL = URL(string: "https://server.com/1")!
        var fetchCount = 0
        let fetcher = { (url: URL) -> Fetcher in
            fetchCount += 1

            return self.makeSuccessFetcher(startID: fetchCount, nextPageURL: page2URL)
        }
        let sut = CharacterListViewModel(fetcher: fetcher)
        sut.fetch()

        sut.characterAppeared(sut.characters[0])

        XCTAssertEqual(fetchCount, 1)
    }

    func test_fetchesWhenPenultimateCharacterAppears() {
        let page2URL = URL(string: "https://server.com/1")!
        var fetchCount = 0
        let fetcher = { (url: URL) -> Fetcher in
            fetchCount += 1

            return self.makeSuccessFetcher(startID: fetchCount, nextPageURL: page2URL)
        }
        let sut = CharacterListViewModel(fetcher: fetcher)
        sut.fetch()

        sut.characterAppeared(sut.characters[2])

        XCTAssertEqual(fetchCount, 2)
    }
}

private extension CharacterListViewModelTests {
    typealias Fetcher = AnyPublisher<Paginated<Character>, Error>

    func makeFailingFetcher() -> Fetcher {
        Fail(error: SampleError()).eraseToAnyPublisher()
    }

    func makeSuccessFetcher(startID: Int = 1, nextPageURL: URL? = nil) -> Fetcher {
        let characters = (startID...startID + 2).map {
            Character.any(id: $0)
        }

        return Just(Paginated(items: characters, nextPageUrl: nextPageURL)).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    private struct SampleError: Error {}
}
