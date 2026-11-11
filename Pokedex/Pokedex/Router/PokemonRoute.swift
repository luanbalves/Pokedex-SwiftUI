//
//  PokemonRoute.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 28/02/25.
//

import SwiftUI

enum PokemonRoute: Hashable {
    case list
    case details(Int)
}

enum PokemonFeatureRouter {
    @ViewBuilder
    static func view(
        for route: PokemonRoute,
        dependencies: AppDependencies
    ) -> some View {
        switch route {
        case .list:
            PokemonListScreen(service: dependencies.makePokemonListService())

        case .details(let pokemonId):
            PokemonDetailsScreen(
                service: dependencies.makePokemonDetailsService(),
                pokemonId: pokemonId
            )
        }
    }
}
