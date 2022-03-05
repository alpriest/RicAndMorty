//
//  StatusView.swift
//  RicAndMorty
//
//  Created by Alistair Priest on 03/03/2022.
//

import SwiftUI

struct StatusView: View {
    let status: Status
    private let size: CGFloat = 8

    var body: some View {
        HStack {
            color
                .cornerRadius(size / 2)
                .frame(width: size, height: size)

            Text(status.rawValue.capitalized)
        }
    }

    var color: Color {
        switch status {
        case .alive:
            return .green.opacity(0.7)
        case .dead:
            return .red.opacity(0.6)
        case .unknown:
            return .gray
        }
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            StatusView(status: .alive)
            StatusView(status: .dead)
            StatusView(status: .unknown)
        }
        .background(Color.black.opacity(0.8))
        .foregroundColor(.white)
    }
}
