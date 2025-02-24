//
//  PokemonService.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 20/02/25.
//

protocol PokemonListServiceable {
    func getAllPokemons(offset: Int?, limit: Int?) async -> Result<PokemonsResponse, RequestError>
}

protocol PokemonDetailsServiceable {
    func getPokemonDetails(id: Int) async -> Result<PokemonDetail, RequestError>
}

struct PokemonService: PokemonListServiceable, PokemonDetailsServiceable, HTTPClient {
    
    func getPokemonDetails(id: Int) async -> Result<PokemonDetail, RequestError> {
        return await sendRequest(endpoint: PokemonEndpoint.getPokemonDetails(id: id), responseModel: PokemonDetail.self)
    }
    
    func getAllPokemons(offset: Int?, limit: Int?) async -> Result<PokemonsResponse, RequestError> {
        return await sendRequest(endpoint: PokemonEndpoint.getAllPokemons(offset: offset, limit: limit), responseModel: PokemonsResponse.self)
    }
}
