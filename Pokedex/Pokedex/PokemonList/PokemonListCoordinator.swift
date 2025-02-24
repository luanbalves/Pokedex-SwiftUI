//
//  PokemonListCoordinator.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 21/02/25.
//

import SwiftUI

protocol PokemonListInterface: AnyObject {
    func pushPokemonDetails(id: Int) -> AnyView
}

class PokemonListCoordinator: PokemonListInterface {
    func pushPokemonDetails(id: Int) -> AnyView {
        let pokemonDetailsScreen = PokemonDetailsFactory.makeModule(id: id)
        return AnyView(pokemonDetailsScreen)
    }
}
