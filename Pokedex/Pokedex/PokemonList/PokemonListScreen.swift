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
        NavigationStack {
            ScrollView {
                LazyVStack {
                    if let pokemons = viewModel.pokemons {
                        ForEach(pokemons, id: \.id) { pokemon in
                            
                            let imageUrl = URL(string: "\(ApiUrls.imageUrl)\(pokemon.id ?? 0).png")
                            
                            VStack {
                                PokemonImageView(
                                    url: imageUrl,
                                    placeholder: Image(systemName: "photo")
                                )
                                Text(pokemon.name)
                                Text("\(pokemon.id ?? 1)")
                                Text(pokemon.url)
                            }
                            .onTapGesture {
                                selectedPokemonId = pokemon.id
                            }
                        }
                    } else {
                        ProgressView()
                    }
                }
            }
            .navigationDestination(item: $selectedPokemonId) { id in
                viewModel.goToPokemonDetails(id: id)
            }
        }
    }
}

#Preview {
    PokemonListFactory.makeModule()
}
