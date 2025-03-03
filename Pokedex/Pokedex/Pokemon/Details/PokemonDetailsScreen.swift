//
//  PokemonDetailsScreen.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 22/02/25.
//

import SwiftUI

struct PokemonDetailsScreen<VM>: View where VM: PokemonDetailsViewModeling {
    @ObservedObject private var viewModel: VM

    init(viewModel: VM) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            if let pokemon = viewModel.pokemon {
                VStack(spacing: 0) {
                    PokemonBackgroundView(pokemon.id)
                    PokemonInfosView(pokemon)
                    Spacer()
                }
            } else {
                ProgressView()
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .toolbar(.hidden)
        .statusBarHidden()
    }
}

#Preview {
    PokemonDetailsScreen(viewModel: PokemonDetailsViewModel(service: PokemonService(), id: 3))
}
