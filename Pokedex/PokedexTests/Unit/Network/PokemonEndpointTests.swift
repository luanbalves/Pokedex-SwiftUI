//
//  PokemonEndpointTests.swift
//  PokedexTests
//
//  Created by Luan Alves Barroso on 11/11/26.
//

import Foundation
import Testing
@testable import Pokedex

struct PokemonEndpointTests {
    @Test func allPokemonEndpointSendsOffsetAndLimitTogether() {
        let endpoint = PokemonEndpoint.getAllPokemons(offset: 20, limit: 24)

        let queryItems = endpoint.queryItems

        #expect(queryItems?.contains(URLQueryItem(name: "offset", value: "20")) == true)
        #expect(queryItems?.contains(URLQueryItem(name: "limit", value: "24")) == true)
        #expect(queryItems?.count == 2)
    }

    @Test func detailEndpointHasNoQueryItems() {
        let endpoint = PokemonEndpoint.getPokemonDetails(id: 25)

        #expect(endpoint.queryItems == nil)
        #expect(endpoint.path == "/api/v2/pokemon/25")
        #expect(endpoint.method == .get)
    }

    @Test func listEndpointPathIsCorrect() {
        let endpoint = PokemonEndpoint.getAllPokemons(offset: nil, limit: nil)

        #expect(endpoint.path == "/api/v2/pokemon/")
        #expect(endpoint.scheme == "https")
        #expect(endpoint.host == ApiUrls.baseUrl)
    }

    @Test func urlRequestIsBuilt() throws {
        let request = try #require(PokemonEndpoint.getPokemonDetails(id: 1).urlRequest)

        #expect(request.url?.absoluteString == "https://pokeapi.co/api/v2/pokemon/1")
        #expect(request.httpMethod == "GET")
    }

    @Test func pokemonIdIsExtractedFromURL() {
        #expect(Pokemon.id(from: "https://pokeapi.co/api/v2/pokemon/25/") == 25)
        #expect(Pokemon.id(from: "https://pokeapi.co/api/v2/pokemon/6") == 6)
        #expect(Pokemon.id(from: "https://pokeapi.co/api/v2/pokemon/") == nil)
    }

    @Test func pokemonComputedIdFallsBackToZero() {
        let pokemon = Pokemon(name: "desconhecido", url: "url-invalida")
        #expect(pokemon.id == 0)
    }

    @Test func favoritePokemonConvertsBackToPokemon() {
        let favorite = FavoritePokemon(id: 445, name: "garchomp")

        let pokemon = favorite.pokemon

        #expect(pokemon.id == 445, "O ID deve ser recuperado da URL reconstruída")
        #expect(pokemon.name == "garchomp")
    }
}
