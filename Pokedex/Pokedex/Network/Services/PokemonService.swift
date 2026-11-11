//
//  PokemonService.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 20/02/25.
//

protocol PokemonListServiceable: Sendable {
    func getAllPokemons(offset: Int?, limit: Int?) async throws -> PokemonsResponse
}

protocol PokemonDetailsServiceable: Sendable {
    func getPokemonDetails(id: Int) async throws -> PokemonDetail
}

struct PokemonService: PokemonListServiceable, PokemonDetailsServiceable {
    private let client: HTTPClient

    init(client: HTTPClient = URLSessionHTTPClient()) {
        self.client = client
    }

    func getAllPokemons(offset: Int?, limit: Int?) async throws -> PokemonsResponse {
        try await client.send(PokemonEndpoint.getAllPokemons(offset: offset, limit: limit))
    }

    func getPokemonDetails(id: Int) async throws -> PokemonDetail {
        try await client.send(PokemonEndpoint.getPokemonDetails(id: id))
    }
}
