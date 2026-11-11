//
//  PokemonDetailsViewModel.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 22/02/25.
//

import SwiftUI

@MainActor
@Observable
final class PokemonDetailsViewModel {
    private let service: PokemonDetailsServiceable
    private(set) var pokemon: PokemonDetail?
    private(set) var error: RequestError?

    let pokemonId: Int

    init(service: PokemonDetailsServiceable, pokemonId: Int) {
        self.service = service
        self.pokemonId = pokemonId
    }

    func reset() {
        pokemon = nil
        error = nil
    }

    func load() async {
        guard pokemon == nil, error == nil else { return }
        error = nil

        do {
            pokemon = try await service.getPokemonDetails(id: pokemonId)
        } catch let requestError as RequestError {
            error = requestError
        } catch is CancellationError {
            // Task cancelada: ignora silenciosamente.
        } catch {
            self.error = .unknown
        }
    }
}
