//
//  PokemonGridView.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 24/02/25.
//

import SwiftUI

struct PokemonGridView: View {
    let pokemons: [Pokemon]
    let onLoadMore: (Pokemon) async -> Void
    let onSelect: (Pokemon) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    init(
        _ pokemons: [Pokemon],
        onLoadMore: @escaping (Pokemon) async -> Void,
        onSelect: @escaping (Pokemon) -> Void
    ) {
        self.pokemons = pokemons
        self.onLoadMore = onLoadMore
        self.onSelect = onSelect
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(pokemons) { pokemon in
                PokemonCardView(pokemon: pokemon)
                    .onTapGesture {
                        onSelect(pokemon)
                    }
                    .task {
                        await onLoadMore(pokemon)
                    }
            }
        }
        .padding()
    }
}

private struct PokemonCardView: View {
    let pokemon: Pokemon

    @State private var dominantColor: Color = .clear

    var body: some View {
        VStack {
            PokemonImageView(
                pokemonId: pokemon.id,
                style: .sprite,
                dominantColor: $dominantColor
            )
            .background(dominantColor)
                .cornerRadius(10)

            Text(pokemon.name.capitalized)
                .font(.headline)
                .foregroundStyle(.primary)

            Text("#\(String(format: "%04d", pokemon.id))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.08), radius: 4)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(pokemon.name.capitalized), número \(pokemon.id)")
        .accessibilityAddTraits(.isButton)
    }
}
