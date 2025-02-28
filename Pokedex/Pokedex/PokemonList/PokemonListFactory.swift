//
//  PokemonListFactory.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 21/02/25.
//

import SwiftUI

enum PokemonListFactory {
    static func makeModule() -> some View {
        PokemonListCoordinator().makeView()
    }
}
