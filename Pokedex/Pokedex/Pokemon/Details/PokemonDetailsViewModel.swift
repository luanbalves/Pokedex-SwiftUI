//
//  PokemonDetailsViewModel.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 22/02/25.
//

import SwiftUI

protocol PokemonDetailsViewModeling: ObservableObject {
    var pokemon: PokemonDetail? { get }
}

class PokemonDetailsViewModel: PokemonDetailsViewModeling {
    private let service: PokemonDetailsServiceable
    @Published var pokemon: PokemonDetail?
    let id: Int
    
    init(service: PokemonDetailsServiceable, id: Int) {
        self.service = service
        self.id = id
        getPokemonDetails(id: id)
    }
    
    func getPokemonDetails(id: Int) {
        Task { @MainActor in
            let result = await service.getPokemonDetails(id: id)

            switch result {
            case .success(let success):
                self.pokemon = success
            case .failure(let failure):
                print(failure.customMessage)
            }
        }
    }
}
