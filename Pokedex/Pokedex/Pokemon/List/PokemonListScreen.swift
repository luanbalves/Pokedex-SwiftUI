//
//  PokemonListScreen.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 20/02/25.
//

import SwiftUI
import SwiftData

@MainActor
struct PokemonListScreen: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.modelContext) private var modelContext
    @Query private var favoritePokemons: [FavoritePokemon]
    @State private var viewModel: PokemonListViewModel
    @State private var showFavoritesOnly = false

    init(service: PokemonListServiceable) {
        _viewModel = State(initialValue: PokemonListViewModel(service: service))
    }

    private var favoriteIds: Set<Int> {
        Set(favoritePokemons.map(\.id))
    }

    private var displayedPokemons: [Pokemon] {
        showFavoritesOnly
            ? viewModel.pokemons.filter { favoriteIds.contains($0.id) }
            : viewModel.pokemons
    }

    var body: some View {
        Group {
            if showFavoritesOnly, !viewModel.pokemons.isEmpty, displayedPokemons.isEmpty {
                favoritesEmptyState
            } else if viewModel.pokemons.isEmpty {
                emptyState
            } else {
                listContent
            }
        }
        .navigationTitle("app.title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                favoritesFilterButton
            }
        }
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
                pokemons: displayedPokemons,
                favoriteIds: favoriteIds,
                onToggleFavorite: toggleFavorite,
                onLoadMore: { await viewModel.loadMoreIfNeeded(current: $0) },
                onSelect: { pokemon in
                    router.navigate(to: .pokemon(.details(pokemon.id)))
                }
            )

            footer
        }
    }

    private var favoritesFilterButton: some View {
        Button {
            showFavoritesOnly.toggle()
        } label: {
            Image(systemName: showFavoritesOnly ? "heart.fill" : "heart")
        }
        .tint(showFavoritesOnly ? .red : .accentColor)
        .accessibilityLabel(showFavoritesOnly
            ? String(localized: "favorites.showAll")
            : String(localized: "favorites.showOnly")
        )
    }

    private var favoritesEmptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
            Text("favorites.empty")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding(24)
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
            ProgressView("list.loading")
        }
    }

    private func toggleFavorite(_ pokemon: Pokemon) {
        if let existing = favoritePokemons.first(where: { $0.id == pokemon.id }) {
            modelContext.delete(existing)
        } else {
            modelContext.insert(FavoritePokemon(id: pokemon.id, name: pokemon.name))
        }
    }
}

#Preview {
    NavigationStack {
        PokemonListScreen(service: PokemonService())
            .environment(AppRouter(dependencies: LiveDependencies()))
    }
    .modelContainer(for: FavoritePokemon.self, inMemory: true)
}
