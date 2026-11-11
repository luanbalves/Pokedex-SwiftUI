//
//  MockPokemonService.swift
//  PokedexTests
//
//  Created by Luan Alves Barroso on 11/03/25.
//

@testable import Pokedex

final class MockPokemonService: PokemonListServiceable, PokemonDetailsServiceable {
    var listHandler: ((Int?, Int?) async throws -> PokemonsResponse)?
    var detailHandler: ((Int) async throws -> PokemonDetail)?

    private(set) var capturedOffsets: [Int?] = []
    private(set) var capturedLimits: [Int?] = []
    private(set) var capturedDetailIds: [Int] = []

    func getAllPokemons(offset: Int?, limit: Int?) async throws -> PokemonsResponse {
        capturedOffsets.append(offset)
        capturedLimits.append(limit)
        if let listHandler {
            return try await listHandler(offset, limit)
        }
        return PokemonsResponse(count: 0, results: [])
    }

    func getPokemonDetails(id: Int) async throws -> PokemonDetail {
        capturedDetailIds.append(id)
        if let detailHandler {
            return try await detailHandler(id)
        }
        throw RequestError.unknown
    }
}
