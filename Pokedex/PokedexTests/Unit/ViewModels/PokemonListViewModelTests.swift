//
//  PokemonListViewModelTests.swift
//  PokedexTests
//
//  Created by Luan Alves Barroso on 11/03/25.
//

import Testing
@testable import Pokedex

@MainActor
struct PokemonListViewModelTests {
    private let mockService = MockPokemonService()
    private var sut: PokemonListViewModel!

    init() {
        sut = PokemonListViewModel(service: mockService)
    }

    private func pokemon(_ id: Int) -> Pokemon {
        Pokemon(name: "pokemon\(id)", url: "https://pokeapi.co/api/v2/pokemon/\(id)/")
    }

    @Test func loadInitialPopulatesPokemons() async {
        mockService.listHandler = { _, _ in
            PokemonsResponse(count: 2, results: [self.pokemon(1), self.pokemon(2)])
        }

        await sut.loadInitial()

        #expect(sut.pokemons.count == 2)
        #expect(sut.pokemons.first?.name == "pokemon1")
        #expect(sut.pokemons.first?.id == 1)
        #expect(sut.totalCount == 2)
        #expect(sut.canLoadMore == false)
        #expect(sut.error == nil)
    }

    @Test func loadInitialSendsOffsetAndLimit() async {
        mockService.listHandler = { _, _ in
            PokemonsResponse(count: 30, results: (1...24).map { self.pokemon($0) })
        }

        await sut.loadInitial()

        #expect(mockService.capturedOffsets == [0])
        #expect(mockService.capturedLimits == [24])
        #expect(sut.canLoadMore == true)
    }

    @Test func loadMoreAppendsNextPage() async {
        mockService.listHandler = { offset, _ in
            switch offset {
            case 0:
                PokemonsResponse(count: 4, results: [self.pokemon(1), self.pokemon(2)])
            default:
                PokemonsResponse(count: 4, results: [self.pokemon(3), self.pokemon(4)])
            }
        }

        await sut.loadInitial()
        await sut.loadMore()

        #expect(sut.pokemons.count == 4)
        #expect(sut.pokemons.map(\.id) == [1, 2, 3, 4])
        #expect(sut.canLoadMore == false)
    }

    @Test func loadMoreDoesNotDuplicate() async {
        mockService.listHandler = { _, _ in
            PokemonsResponse(count: 4, results: [self.pokemon(1), self.pokemon(2)])
        }

        await sut.loadInitial()
        await sut.loadMore()

        #expect(sut.pokemons.count == 2)
    }

    @Test func loadMoreIfNeededTriggersOnlyForLastPokemon() async {
        mockService.listHandler = { offset, _ in
            switch offset {
            case 0:
                PokemonsResponse(count: 4, results: [self.pokemon(1), self.pokemon(2)])
            default:
                PokemonsResponse(count: 4, results: [self.pokemon(3), self.pokemon(4)])
            }
        }

        await sut.loadInitial()

        await sut.loadMoreIfNeeded(current: pokemon(1))
        #expect(mockService.capturedOffsets.count == 1, "Não deveria carregar mais páginas para itens que não são o último")

        await sut.loadMoreIfNeeded(current: pokemon(2))
        #expect(mockService.capturedOffsets.count == 2)
        #expect(sut.pokemons.count == 4)
    }

    @Test func failureSetsErrorAndRetryRecovers() async {
        mockService.listHandler = { _, _ in
            throw RequestError.unexpectedStatusCode
        }

        await sut.loadInitial()

        #expect(sut.pokemons.isEmpty)
        #expect(sut.error == .unexpectedStatusCode)

        mockService.listHandler = { _, _ in
            PokemonsResponse(count: 2, results: [self.pokemon(1), self.pokemon(2)])
        }

        await sut.reload()

        #expect(sut.pokemons.count == 2)
        #expect(sut.error == nil)
    }

    @Test func reloadResetsList() async {
        mockService.listHandler = { _, _ in
            PokemonsResponse(count: 2, results: [self.pokemon(1), self.pokemon(2)])
        }

        await sut.loadInitial()
        await sut.reload()

        #expect(sut.pokemons.count == 2)
        #expect(mockService.capturedOffsets == [0, 0], "Reload deve recomeçar do offset 0")
    }
}
