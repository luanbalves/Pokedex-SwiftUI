//
//  PokemonGridView.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 24/02/25.
//

import SwiftUI

struct PokemonGridView: View {
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    var pokemons: [Pokemon]?
    let onSelect: (Pokemon) -> Void

    init(_ pokemons: [Pokemon]?, onSelect: @escaping (Pokemon) -> Void) {
        self.pokemons = pokemons
        self.onSelect = onSelect
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            if let pokemons = pokemons {
                ForEach(pokemons, id: \.id) { pokemon in
                    PokemonCardView(pokemon)
                        .onTapGesture {
                            onSelect(pokemon)
                        }
                }
            } else {
                ProgressView()
            }
        }
        .padding()
    }
}

private struct PokemonCardView: View {
    let pokemon: Pokemon
    @State private var dominantColor: Color = .clear

    init(_ pokemon: Pokemon) {
        self.pokemon = pokemon
    }

    var body: some View {
        VStack {
            let imageUrl = URL(string: "\(ApiUrls.imageUrl)\(pokemon.id ?? 0).png")

            PokemonImageView(
                url: imageUrl,
                placeholder: Image(systemName: "photo"),
                dominantColor: $dominantColor
            )
            .background(dominantColor)
            .cornerRadius(10)

            Text(pokemon.name.capitalized)
                .font(.headline)
                .foregroundStyle(.black)

            Text("#\(String(format: "%04d", pokemon.id ?? 1))")
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}
