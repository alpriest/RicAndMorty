//
//  String+Extensions.swift
//  RicAndMorty
//
//  Created by Alistair Priest on 03/03/2022.
//

import Foundation

extension String {
    static func validURL() -> String {
        "https://server.com/something"
    }

    static func invalidURL() -> String {
        "not a url"
    }
}
