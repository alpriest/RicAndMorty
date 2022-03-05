import XCTest
@testable import RicAndMortyCore
import Combine

final class NetworkFetcherTests: XCTestCase {
    func test_failsToDecodeInvalidResponse() {
        let expectation = self.expectation(description: "should fail")
        let sut = makeSUT(responseContent: failingDataURL)

        _ = sut.fetch(makeURL())
            .sink { result in
                if case .failure = result {
                    expectation.fulfill()
                }
            } receiveValue: { (_: PaginatedBlueprint<Example>) in
                XCTFail("Unexpected value received")
            }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_decodesValidResponse() {
        let sut = makeSUT(responseContent: successfulDataURL)

        _ = sut.fetch(makeURL())
            .sink { result in
                if case let .failure(error) = result {
                    XCTFail("Unexpected failure \(error)")
                }
            } receiveValue: { (result: PaginatedBlueprint<Example>) in
                XCTAssertEqual(result.results.count, 2)
            }
    }
}

private extension NetworkFetcherTests {
    func makeSUT(responseContent url: URL) -> NetworkFetcher {
        do {
            let data = try Data(contentsOf: url)

            let response: URLSession.DataTaskPublisher.Output = (data, HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!)

            return NetworkFetcher({ _ in Just(response).setFailureType(to: URLError.self).eraseToAnyPublisher() })
        } catch {
            XCTFail()
            return NetworkFetcher({ _ in Fail(error: URLError(.fileDoesNotExist)).eraseToAnyPublisher() })
        }
    }

    var successfulDataURL: URL {
        Bundle.module.url(forResource: "success", withExtension: "json")!
    }

    var failingDataURL: URL {
        Bundle.module.url(forResource: "invalid", withExtension: "json")!
    }
}

extension XCTestCase {
    func makeURL() -> URL {
        URL(string: "https://server.com/something")!
    }
}

struct Example: Decodable {
    let name: String
}
