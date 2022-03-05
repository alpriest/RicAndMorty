//
//  ErrorView.swift
//  RicAndMorty
//
//  Created by Alistair Priest on 04/03/2022.
//

import SwiftUI

struct ErrorView: View {
    let error: String
    let onRetry: () -> Void
    
    var body: some View {
        ZStack(alignment: .center) {
            Button(action: onRetry) {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.largeTitle)
                    
                    Text(error)
                    
                    Text("Tap to retry")
                        .font(.caption)
                        .padding(.top)
                }
                .padding()
                .background(Color.itemBackground)
                .cornerRadius(12)
                .foregroundColor(.white)
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: "Something went wrong", onRetry: {})
    }
}
