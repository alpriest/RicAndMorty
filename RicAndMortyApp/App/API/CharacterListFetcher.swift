//
//  CharacterListFetcher.swift
//  RicAndMorty
//
//  Created by Alistair Priest on 04/03/2022.
//

import Foundation
import Combine
import RicAndMortyCore

final class CharacterListFetcher {
    typealias Fetcher = (URL) -> AnyPublisher<PaginatedBlueprint<CharacterBlueprint>, Error>
    private let fetcher: Fetcher

    init(_ fetcher: @escaping Fetcher = NetworkFetcher().fetch) {
        self.fetcher = fetcher
    }

    func fetch(_ nextPageUrl: URL) -> AnyPublisher<Paginated<Character>, Error> {
        fetcher(nextPageUrl)
            .map {
                Paginated(items: $0.results.compactMap(self.map),
                          nextPageUrl: $0.info.next)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    private func map(_ source: CharacterBlueprint) -> Character? {
        guard let url = URL(string: source.image) else { return nil }

        return Character(id: source.id,
                         image: url,
                         name: source.name,
                         species: source.species,
                         status: Status.build(from: source.status),
                         lastKnownLocation: source.location.name)
    }
}
