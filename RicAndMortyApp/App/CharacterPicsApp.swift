//
//  CharacterApp.swift
//  RicAndMorty
//
//  Created by Alistair Priest on 03/03/2022.
//

import SwiftUI

@main
struct CharacterPicsApp: App {
    init() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.backgroundColor = UIColor.orange
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                CharacterListView(viewModel: CharacterListViewModel())
            }
            .navigationViewStyle(.stack)
        }
    }
}
