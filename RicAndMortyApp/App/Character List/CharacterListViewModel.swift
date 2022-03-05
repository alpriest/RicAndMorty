//
//  MainViewModel.swift
//  RicAndMorty
//
//  Created by Alistair Priest on 03/03/2022.
//

import Foundation
import Combine
import RicAndMortyCore

final class CharacterListViewModel: ObservableObject {
    typealias Fetcher = (URL) -> AnyPublisher<Paginated<Character>, Error>

    @Published var characters: [Character] = []
    @Published var error: String?
    private var fetchRequest: AnyCancellable?
    private var nextPageUrl: URL? = URLS.characterList()
    private let fetcher: Fetcher

    init(fetcher: @escaping Fetcher = CharacterListFetcher().fetch) {
        self.fetcher = fetcher
    }

    func fetch() {
        guard let nextPageUrl = nextPageUrl else {
            return
        }

        self.error = nil
        
        fetchRequest = fetcher(nextPageUrl)
            .sink { [weak self] result in
                if case .failure = result {
                    self?.error = "LOAD_FAILURE".localized()
                }
            } receiveValue: { [weak self] result in
                self?.characters.append(contentsOf: result.items)
                self?.nextPageUrl = result.nextPageUrl
            }
    }

    func characterAppeared(_ character: Character) {
        guard let index = characters.firstIndex(of: character) else { return }

        if index == characters.count - 1, characters.count > 0 {
            fetch()
        }
    }
}
