//
//  CharacterListView.swift
//  RicAndMorty
//
//  Created by Alistair Priest on 03/03/2022.
//

import SwiftUI
import Combine
import RicAndMortyCore

struct CharacterListView: View {
    @ObservedObject var viewModel: CharacterListViewModel

    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(Array(viewModel.characters.enumerated()), id: \.element) { index, character in
                        CharacterView(character: character)
                            .onAppear {
                                viewModel.characterAppeared(character)
                            }
                            .padding(.top)
                            .padding(.horizontal)
                    }
                }
            }

            if let error = viewModel.error {
                ErrorView(error: error, onRetry: { viewModel.fetch() })
                    .shadow(color: .white, radius: 10)
            }
        }
        .onAppear { viewModel.fetch() }
        .background(Color.appBackground)
        .navigationTitle(Text("Ric and Morty"))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let models = (1...3).map { Character.any(id: $0) }
        let successFetcher = Just(Paginated<Character>(items: models, nextPageUrl: URL(string: "https://server.com")!)).setFailureType(to: Error.self).eraseToAnyPublisher()
        let failureFetcher = Fail<Paginated<Character>, Error>(error: NSError(domain: "Could not read from network", code: 0, userInfo: nil)).eraseToAnyPublisher()

        return Group {
            NavigationView {
                CharacterListView(viewModel: CharacterListViewModel(fetcher: { _ in successFetcher }))
            }
            NavigationView {
                CharacterListView(viewModel: CharacterListViewModel(fetcher: { _ in failureFetcher }))
            }
        }
    }
}
