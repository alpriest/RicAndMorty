import Foundation
import Combine

public final class NetworkFetcher {
    public struct ParseError: Error {}
    public typealias Publisher = (URL) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLError>

    private let publisher: Publisher

    public init(_ publisher: @escaping Publisher = { (url: URL) in URLSession.shared.dataTaskPublisher(for: url).eraseToAnyPublisher() }) {
        self.publisher = publisher
    }

    public func fetch<T: Decodable>(_ url: URL) -> AnyPublisher<PaginatedBlueprint<T>, Error> {
        publisher(url)
            .tryMap(\.data)
            .decode(type: PaginatedBlueprint.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
