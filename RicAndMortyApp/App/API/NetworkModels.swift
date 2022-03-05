//
//  NetworkModels.swift
//  RicAndMorty
//
//  Created by Alistair Priest on 03/03/2022.
//

import Foundation

struct Paginated<T> {
    let items: [T]
    let nextPageUrl: URL?
}

struct CharacterBlueprint: Decodable, Equatable {
    let id: Int
    let name: String
    let status: StatusBlueprint
    let species: String
    let image: String
    let location: LocationBlueprint
}

enum StatusBlueprint: String, Decodable {
    case alive
    case dead
    case unknown

    init(from decoder: Decoder) throws {
        guard let value = try? decoder.singleValueContainer().decode(String.self) else {
            self = .unknown
            return
        }

        self = StatusBlueprint(rawValue: value.lowercased()) ?? .unknown
    }
}

struct LocationBlueprint: Decodable, Equatable {
    let name: String
}
