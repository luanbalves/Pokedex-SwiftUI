//
//  PokemonListScreen.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 20/02/25.
//

import SwiftUI

struct PokemonListScreen<VM>: View where VM: PokemonListViewModeling {
    @ObservedObject private var viewModel: VM
    @State private var selectedPokemonId: Int?
    
    init(viewModel: VM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
            ScrollView {
                PokemonGridView(viewModel.pokemons, onSelect: viewModel.selectPokemon)
            }
    }
}

#Preview {
    PokemonListFactory.makeModule()
}
