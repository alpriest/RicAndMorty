//
//  AppSettings.swift
//  RicAndMorty
//
//  Created by Alistair Priest on 05/03/2022.
//

import Foundation

class AppSettings {
    struct MissingKeyError: Error {
        let name: String
    }
    private let dictionary: [String: Any]?

    init(dictionary: [String: Any]? = Bundle.main.infoDictionary) {
        self.dictionary = dictionary
    }

    func hostName() throws -> String {
        try fetch("API_HOST")
    }

    private func fetch(_ key: String) throws -> String {
        guard let infoDictionary = dictionary,
              let value = infoDictionary[key] as? String,
              !value.isEmpty
        else {
            throw MissingKeyError(name: key)
        }

        return value
    }
}
