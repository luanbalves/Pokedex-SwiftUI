//
//  PokemonDetailsFactory.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 02/03/25.
//

import SwiftUI

protocol PokemonDetailsFactory {
    associatedtype VM: PokemonDetailsViewModeling
    func createViewModel(service: PokemonDetailsServiceable, pokemonId: Int) -> VM
}

struct DefaultPokemonDetailsModule: PokemonDetailsFactory {
    func createViewModel(service: any PokemonDetailsServiceable, pokemonId: Int) -> some PokemonDetailsViewModeling {
        PokemonDetailsViewModel(service: service, id: pokemonId)
    }
}

struct PokemonDetailsModule<Factory: PokemonDetailsFactory>: View {
    @StateObject private var viewModel: Factory.VM
    let factory: Factory
    
    init(factory: Factory, service: PokemonDetailsServiceable, pokemonId: Int) {
        self.factory = factory
        _viewModel = StateObject(wrappedValue: factory.createViewModel(service: service, pokemonId: pokemonId))
    }
    
    var body: some View {
        PokemonDetailsScreen(viewModel: viewModel)
    }
}
