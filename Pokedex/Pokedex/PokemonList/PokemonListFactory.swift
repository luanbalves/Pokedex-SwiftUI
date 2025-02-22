//
//  PokemonListFactory.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 21/02/25.
//

import SwiftUI

struct PokemonListFactory {
    static func makeModule() -> some View {
        let service = PokemonService()
        let coordinator = PokemonListCoordinator()
        let viewModel = PokemonListViewModel(service: service, coordinator: coordinator)
        return PokemonListScreen(viewModel: viewModel)
    }
}
