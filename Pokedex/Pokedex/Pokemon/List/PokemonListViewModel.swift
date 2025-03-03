//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 20/02/25.
//

import SwiftUI

protocol PokemonListViewModeling: ObservableObject {
    var pokemons: [Pokemon]? { get }
}

class PokemonListViewModel: PokemonListViewModeling {
    private let service: PokemonListServiceable
    @Published var pokemons: [Pokemon]?
    
    init(service: PokemonListServiceable) {
        self.service = service
        getAllPokemon(offset: nil, limit: nil)
    }
    
    private func updatePokemonsId(_ pokemons: [Pokemon]) {
        self.pokemons = pokemons.map { pokemon in
            var updatedPokemon = pokemon
            if let idString = Extracters.extractPokemonId(from: pokemon.url),
               let id = Int(idString) {
                updatedPokemon.id = id
            }
            return updatedPokemon
        }
    }
    
    private func getAllPokemon(offset: Int?, limit: Int?) {
        Task { @MainActor in
            let result = await service.getAllPokemons(offset: offset, limit: limit)
            
            switch result {
            case .success(let success):
                self.updatePokemonsId(success.results)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}


