//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 20/02/25.
//

import SwiftUI

@main
struct PokedexApp: App {
    init() {
        URLProtocol.registerClass(PrintProtocol.self)
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                PokemonListFactory.makeModule()
            }
        }
    }
}
