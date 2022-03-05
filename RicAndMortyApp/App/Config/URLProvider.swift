//
//  URLProvider.swift
//  RicAndMorty
//
//  Created by Alistair Priest on 05/03/2022.
//

import Foundation

enum URLS {
    static func characterList() -> URL {
        do {
            return try URL(string: "\(AppSettings().hostName())/api/character")!
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
