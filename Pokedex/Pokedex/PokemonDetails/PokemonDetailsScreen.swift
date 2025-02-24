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
                Text(pokemon.name)
                Text(pokemon.height.description)
                Text(pokemon.weight.description)
                Text(pokemon.baseExperience.description)
                Text(pokemon.types[0].type.name)
                if pokemon.types.count > 1 {
                    Text(pokemon.types[1].type.name)
                }
                
            } else {
                ProgressView()
            }
        }
    }
}

#Preview {
    PokemonDetailsFactory.makeModule(id: 1)
}
