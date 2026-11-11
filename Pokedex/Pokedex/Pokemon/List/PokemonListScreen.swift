//
//  PokemonListScreen.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 20/02/25.
//

import SwiftUI

struct PokemonListScreen: View {
    @Environment(AppRouter.self) private var router
    @State private var viewModel: PokemonListViewModel

    init(service: PokemonListServiceable) {
        _viewModel = State(initialValue: PokemonListViewModel(service: service))
    }

    var body: some View {
        Group {
            if viewModel.pokemons.isEmpty {
                emptyState
            } else {
                listContent
            }
        }
        .navigationTitle("Pokédex")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadInitial()
        }
        .refreshable {
            await viewModel.reload()
        }
    }

    private var listContent: some View {
        ScrollView {
            PokemonGridView(
                viewModel.pokemons,
                onLoadMore: { await viewModel.loadMoreIfNeeded(current: $0) },
                onSelect: { pokemon in
                    router.navigate(to: .pokemon(.details(pokemon.id)))
                }
            )

            footer
        }
    }

    @ViewBuilder
    private var footer: some View {
        if viewModel.isLoading {
            ProgressView()
                .padding(.bottom, 16)
        } else if let error = viewModel.error, viewModel.canLoadMore {
            ErrorStateView(error: error) {
                Task { await viewModel.loadMore() }
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private var emptyState: some View {
        if let error = viewModel.error {
            ErrorStateView(error: error) {
                Task { await viewModel.reload() }
            }
        } else {
            ProgressView("Carregando Pokédex...")
        }
    }
}

#Preview {
    NavigationStack {
        PokemonListScreen(service: PokemonService())
            .environment(AppRouter(dependencies: LiveDependencies()))
    }
}
