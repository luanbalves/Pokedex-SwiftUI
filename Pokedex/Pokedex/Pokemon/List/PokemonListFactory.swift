//
//  PokemonListFactory.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 28/02/25.
//

import SwiftUI

protocol PokemonListFactory {
    associatedtype VM: PokemonListViewModeling
    func createViewModel(service: PokemonListServiceable) -> VM
}

struct DefaultPokemonListModule: PokemonListFactory {
    func createViewModel(service: PokemonListServiceable) -> some PokemonListViewModeling {
        PokemonListViewModel(service: service)
    }
}

struct PokemonListModule<Factory: PokemonListFactory>: View {
    @StateObject private var viewModel: Factory.VM
    let factory: Factory
    
    init(factory: Factory, service: PokemonListServiceable) {
        self.factory = factory
        _viewModel = StateObject(wrappedValue: factory.createViewModel(service: service))
    }
    
    var body: some View {
        PokemonListScreen(viewModel: viewModel)
    }
}
