//
//  String+Extensions.swift
//  RicAndMorty
//
//  Created by Alistair Priest on 03/03/2022.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, comment: self)
    }
}
