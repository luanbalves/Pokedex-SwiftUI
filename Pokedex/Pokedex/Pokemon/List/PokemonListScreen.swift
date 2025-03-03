//
//  PokemonListScreen.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 20/02/25.
//

import SwiftUI

struct PokemonListScreen<VM>: View where VM: PokemonListViewModeling {
    @ObservedObject private var viewModel: VM
    @EnvironmentObject var router: AppRouter
    
    init(viewModel: VM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
            ScrollView {
                PokemonGridView(
                    viewModel.pokemons,
                    onSelect: navigateToPokemonDetails
                )
            }
    }
    
    private func navigateToPokemonDetails(_ pokemon: Pokemon) {
        router.navigate(to: .pokemon(.details(pokemon.id ?? 1)))
    }
}

#Preview {
    PokemonListScreen(viewModel: PokemonListViewModel(service: PokemonService()))
}
