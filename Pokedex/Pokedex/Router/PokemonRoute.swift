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

struct PokemonFeatureRouter {
    @ViewBuilder
    static func view(
        for route: PokemonRoute,
        router: AppRouter
    ) -> some View {
        switch route {
        case .list:
            let factory = DefaultPokemonListModule()
            let service = router.dependencies.makePokemonListService()
            PokemonListModule(factory: factory, service: service)
            
        case .details(let pokemonId):
            let service = router.dependencies.makePokemonDetailsService()
            let factory = DefaultPokemonDetailsModule()
            PokemonDetailsModule(factory: factory, service: service, pokemonId: pokemonId)
        }
    }
}
