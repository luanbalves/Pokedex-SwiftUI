//
//  PokemonGridView.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 24/02/25.
//

import SwiftUI

struct PokemonGridView: View {
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    var pokemons: [Pokemon]?
    @Binding var selectedPokemonId: Int?
    
    init(_ pokemons: [Pokemon]?, _ selectedPokemonId: Binding<Int?>) {
        self.pokemons = pokemons
        self._selectedPokemonId = selectedPokemonId
    }
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            if let pokemons = pokemons {
                ForEach(pokemons, id: \.id) { pokemon in
                    PokemonCardView(pokemon)
                    .onTapGesture {
                        selectedPokemonId = pokemon.id
                    }
                }
            } else {
                ProgressView()
            }
        }
        .padding()
    }
}

private struct PokemonCardView: View {
    let pokemon: Pokemon
    
    init(_ pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    var body: some View {
        VStack {
            let imageUrl = URL(string: "\(ApiUrls.imageUrl)\(pokemon.id ?? 0).png")

            PokemonImageView(
                url: imageUrl,
                placeholder: Image(systemName: "photo")
            )
            Text(pokemon.name.capitalized)
                .font(.headline)
                .foregroundStyle(.black)
            
            Text("#\(String(format: "%04d", pokemon.id ?? 1))")
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}
