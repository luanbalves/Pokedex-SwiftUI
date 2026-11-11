//
//  AppDependencies.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 28/02/25.
//

import Foundation

protocol AppDependencies {
    func makePokemonListService() -> PokemonListServiceable
    func makePokemonDetailsService() -> PokemonDetailsServiceable
}

final class LiveDependencies: AppDependencies {
    func makePokemonListService() -> any PokemonListServiceable {
        PokemonService()
    }

    func makePokemonDetailsService() -> any PokemonDetailsServiceable {
        PokemonService()
    }
}
