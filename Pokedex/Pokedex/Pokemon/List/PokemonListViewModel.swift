//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 20/02/25.
//

import SwiftUI

@MainActor
@Observable
final class PokemonListViewModel {
    private let service: PokemonListServiceable

    private(set) var pokemons: [Pokemon] = []
    private(set) var totalCount = 0
    private(set) var isLoading = false
    private(set) var error: RequestError?

    private var offset = 0
    private let pageSize = 24

    init(service: PokemonListServiceable) {
        self.service = service
    }

    var canLoadMore: Bool {
        pokemons.count < totalCount
    }

    /// Carrega a primeira página se a lista ainda estiver vazia.
    func loadInitial() async {
        guard pokemons.isEmpty, !isLoading else { return }
        await loadPage(reset: true)
    }

    /// Recarrega do zero (pull to refresh).
    func reload() async {
        guard !isLoading else { return }
        offset = 0
        await loadPage(reset: true)
    }

    /// Carrega a próxima página (scroll infinito e botão "tentar novamente").
    func loadMore() async {
        guard canLoadMore, !isLoading else { return }
        await loadPage(reset: false)
    }

    /// Carrega a próxima página quando o último card aparece na tela.
    func loadMoreIfNeeded(current pokemon: Pokemon) async {
        guard pokemon.id == pokemons.last?.id else { return }
        await loadMore()
    }

    private func loadPage(reset: Bool) async {
        isLoading = true
        error = nil

        do {
            let response = try await service.getAllPokemons(offset: offset, limit: pageSize)
            totalCount = response.count

            if reset {
                pokemons = response.results
            } else {
                let known = Set(pokemons.map(\.url))
                let newOnes = response.results.filter { !known.contains($0.url) }
                pokemons.append(contentsOf: newOnes)
            }
            offset = pokemons.count
        } catch let requestError as RequestError {
            error = requestError
        } catch is CancellationError {
            // Task cancelada: ignora silenciosamente.
        } catch {
            self.error = .unknown
        }

        isLoading = false
    }
}
