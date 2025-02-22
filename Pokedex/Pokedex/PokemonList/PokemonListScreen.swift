//
//  PokemonListScreen.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 20/02/25.
//

import SwiftUI

struct PokemonListScreen<VM>: View where VM: PokemonListViewModeling {
    @ObservedObject private var viewModel: VM
    
    init(viewModel: VM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            if let pokemons = viewModel.pokemons {
                ForEach(pokemons, id: \.id) { pokemon in
                    VStack {
                        Text(pokemon.name)
                        Text("\(pokemon.id ?? 1)")
                        Text(pokemon.url)
                    }
                }
            }
        }
    }
}

#Preview {
    PokemonListFactory.makeModule()
}
