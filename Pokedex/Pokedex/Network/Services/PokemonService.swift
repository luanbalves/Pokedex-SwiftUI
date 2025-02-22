//
//  PokemonService.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 20/02/25.
//

protocol PokemonListServiceable {
    func getAllPokemons(offset: Int?, limit: Int?) async -> Result<PokemonsResponse, RequestError>
}

struct PokemonService: PokemonListServiceable, HTTPClient {
    func getAllPokemons(offset: Int?, limit: Int?) async -> Result<PokemonsResponse, RequestError> {
        return await sendRequest(endpoint: PokemonEndpoint.getAllPokemons(offset: offset, limit: limit), responseModel: PokemonsResponse.self)
    }
}
