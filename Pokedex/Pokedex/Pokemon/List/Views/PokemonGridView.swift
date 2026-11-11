//
//  PokemonGridView.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 24/02/25.
//

import SwiftUI

@MainActor
struct PokemonGridView: View {
    let pokemons: [Pokemon]
    let favoriteIds: Set<Int>
    let onToggleFavorite: (Pokemon) -> Void
    let onLoadMore: (Pokemon) async -> Void
    let onSelect: (Pokemon) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    init(
        pokemons: [Pokemon],
        favoriteIds: Set<Int>,
        onToggleFavorite: @escaping (Pokemon) -> Void,
        onLoadMore: @escaping (Pokemon) async -> Void,
        onSelect: @escaping (Pokemon) -> Void
    ) {
        self.pokemons = pokemons
        self.favoriteIds = favoriteIds
        self.onToggleFavorite = onToggleFavorite
        self.onLoadMore = onLoadMore
        self.onSelect = onSelect
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(pokemons) { pokemon in
                PokemonCardView(
                    pokemon: pokemon,
                    isFavorite: favoriteIds.contains(pokemon.id),
                    onToggleFavorite: { onToggleFavorite(pokemon) }
                )
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
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    @State private var dominantColor: Color = .clear

    var body: some View {
        VStack {
            imageArea

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
    }

    private var imageArea: some View {
        PokemonImageView(
            pokemonId: pokemon.id,
            style: .sprite,
            dominantColor: $dominantColor
        )
        .background(dominantColor)
        .cornerRadius(10)
        .overlay(alignment: .topTrailing) {
            favoriteButton
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(pokemon.name.capitalized), #\(pokemon.id)")
        .accessibilityAddTraits(.isButton)
    }

    private var favoriteButton: some View {
        Button(action: onToggleFavorite) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.subheadline.bold())
                .padding(6)
                .background(.ultraThinMaterial, in: Circle())
        }
        .tint(isFavorite ? .red : .primary)
        .accessibilityLabel(isFavorite
            ? String(localized: "favorites.remove")
            : String(localized: "favorites.add")
        )
    }
}
