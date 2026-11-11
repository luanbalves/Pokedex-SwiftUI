//
//  PokemonDetailsViewModelTests.swift
//  PokedexTests
//
//  Created by Luan Alves Barroso on 11/11/26.
//

import Testing
@testable import Pokedex

@MainActor
struct PokemonDetailsViewModelTests {
    private let mockService = MockPokemonService()

    private func makeSUT() -> PokemonDetailsViewModel {
        PokemonDetailsViewModel(service: mockService, pokemonId: 25)
    }

    private func detail(id: Int) -> PokemonDetail {
        PokemonDetail(
            id: id,
            name: "pikachu",
            baseExperience: 112,
            height: 4,
            weight: 60,
            types: []
        )
    }

    @Test func loadPopulatesPokemon() async {
        mockService.detailHandler = { _ in
            self.detail(id: 25)
        }
        let sut = makeSUT()

        await sut.load()

        #expect(sut.pokemon?.name == "pikachu")
        #expect(sut.error == nil)
        #expect(mockService.capturedDetailIds == [25])
    }

    @Test func failureSetsError() async {
        mockService.detailHandler = { _ in
            throw RequestError.decode
        }
        let sut = makeSUT()

        await sut.load()

        #expect(sut.pokemon == nil)
        #expect(sut.error == .decode)
    }

    @Test func resetClearsState() async {
        mockService.detailHandler = { _ in
            self.detail(id: 25)
        }
        let sut = makeSUT()

        await sut.load()
        sut.reset()

        #expect(sut.pokemon == nil)
        #expect(sut.error == nil)
    }
}
