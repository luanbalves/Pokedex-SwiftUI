//
//  PokemonBackgroundView.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 26/02/25.
//

import SwiftUI

struct PokemonBackgroundView: View {
    @State private var dominantColor: Color = .clear
    let pokemonId: Int
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .top) {
            self.dominantColor.frame(height: UIScreen.main.bounds.height * 0.35)

            let imageUrl = URL(string: "\(ApiUrls.imageUrl)\(pokemonId).png")

            PokemonImageView(
                url: imageUrl,
                placeholder: Image(systemName: "photo"),
                dominantColor: self.$dominantColor
            )
            .frame(width: 200, height: 200)
            .padding(.top, 50)
        }
        .frame(maxWidth: .infinity)
        .overlay {
            ZStack(alignment: .topTrailing) {
                closeButton
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.top, 20)
            }
        }
    }

    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .bold()
                .frame(width: 20, height: 20)
                .padding(10)
                .background(Color(red: 84/255, green: 84/255, blue: 84/255))
                .clipShape(Circle())
        }
        .tint(.white)
        .padding([.horizontal, .top], 20)
    }
}
