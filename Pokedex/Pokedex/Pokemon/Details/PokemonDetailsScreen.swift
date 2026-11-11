//
//  PokemonDetailsScreen.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 22/02/25.
//

import SwiftUI

@MainActor
struct PokemonDetailsScreen: View {
    @State private var viewModel: PokemonDetailsViewModel

    init(service: PokemonDetailsServiceable, pokemonId: Int) {
        _viewModel = State(initialValue: PokemonDetailsViewModel(service: service, pokemonId: pokemonId))
    }

    var body: some View {
        VStack {
            if let pokemon = viewModel.pokemon {
                VStack(spacing: 0) {
                    PokemonBackgroundView(pokemon.id)
                    PokemonInfosView(pokemon)
                    Spacer()
                }
            } else if let error = viewModel.error {
                ErrorStateView(error: error) {
                    Task { await reload() }
                }
            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(.all, edges: .top)
        .toolbar(.hidden)
        .statusBarHidden()
        .task {
            await viewModel.load()
        }
    }

    private func reload() async {
        await viewModel.reset()
        await viewModel.load()
    }
}

#Preview {
    PokemonDetailsScreen(service: PokemonService(), pokemonId: 3)
}
