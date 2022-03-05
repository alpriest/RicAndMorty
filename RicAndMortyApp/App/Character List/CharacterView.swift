//
//  CatView.swift
//  RicAndMorty
//
//  Created by Alistair Priest on 03/03/2022.
//

import SwiftUI

struct CharacterView: View {
    let character: Character

    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: character.image) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)

            } placeholder: {
                Color.clear
            }
            .frame(width: 100)

            VStack(alignment: .leading, spacing: 2) {
                Text(character.name)
                    .bold()
                    .padding(.top, 4)

                HStack(spacing: 2) {
                    StatusView(status: character.status)
                    Text(" - ")
                    Text(character.species)
                    Spacer()
                }
                .font(.caption)
                .padding(.bottom)

                Text("Last known location:")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.caption2)

                Text(character.lastKnownLocation)
                    .font(.caption)
                    .padding(.bottom)
            }
        }
        .foregroundColor(.white)
        .background(Color.itemBackground)
        .cornerRadius(14)
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterView(character: .any())
    }

}

extension Character {
    static func any(id: Int = 1) -> Character {
        .init(
            id: id,
            image: URL(string: "https://25.media.tumblr.com/tumblr_m4gjqmNI3m1qhwmnpo1_500.jpg")!,
            name: "Brad \(id)",
            species: "Human",
            status: .alive,
            lastKnownLocation: "Earth"
        )
    }
}
