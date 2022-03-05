//
//  Models.swift
//  RicAndMorty
//
//  Created by Alistair Priest on 03/03/2022.
//

import Foundation

struct Character: Identifiable, Hashable {
    let id: Int
    let image: URL
    let name: String
    let species: String
    let status: Status
    let lastKnownLocation: String
}

enum Status: String {
    case alive
    case dead
    case unknown

    static func build(from value: StatusBlueprint) -> Status {
        switch value {
        case .alive:
            return .alive
        case .dead:
            return .dead
        case .unknown:
            return .unknown
        }
    }
}
