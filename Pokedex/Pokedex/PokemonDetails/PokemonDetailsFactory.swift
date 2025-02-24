//
//  PokemonDetailsFactory.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 22/02/25.
//

import SwiftUI

struct PokemonDetailsFactory {
    static func makeModule(id: Int) -> some View {
        let service = PokemonService()
        let viewModel = PokemonDetailsViewModel(service: service, id: id)
        return PokemonDetailsScreen(viewModel: viewModel)
    }
}
