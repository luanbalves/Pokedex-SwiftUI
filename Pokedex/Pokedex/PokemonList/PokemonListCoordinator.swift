//
//  PokemonListCoordinator.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 21/02/25.
//

import SwiftUI

class PokemonListCoordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()

    func makeView() -> some View {
        NavigationStackWrapper(coordinator: self)
    }

    private struct NavigationStackWrapper: View {
        @ObservedObject var coordinator: PokemonListCoordinator

        var body: some View {
            NavigationStack(path: $coordinator.navigationPath) {
                PokemonListScreen(viewModel: coordinator.makeViewModel())
                    .navigationDestination(for: Pokemon.self) { pokemon in
                        PokemonDetailsFactory.makeModule(id: pokemon.id ?? 1)
                    }
            }
        }
    }

    private func makeViewModel() -> PokemonListViewModel {
        let service = PokemonService()
        let viewModel = PokemonListViewModel(service: service)
        viewModel.onPokemonSelected = { [weak self] pokemon in
            self?.navigationPath.append(pokemon)
        }
        return viewModel
    }
}
