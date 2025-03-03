//
//  PokemonInfosView.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 26/02/25.
//

import SwiftUI

struct PokemonInfosView: View {
    let pokemon: PokemonDetail
    
    init(_ pokemon: PokemonDetail) {
        self.pokemon = pokemon
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(pokemon.name.capitalized)
                .font(.largeTitle)
                .padding(.top, 20)

            statsSection
            typesSection
        }
        .padding(.horizontal, 20)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .offset(y: -40)
    }
    
    private var statsSection: some View {
        Group {
            Text("Detalhes")
                .font(.title2)
                .bold()

            InfoRow(label: "Altura", value: "\(pokemon.height) dm")
            InfoRow(label: "Peso", value: "\(pokemon.weight) hg")
            InfoRow(label: "Experiência", value: "\(pokemon.baseExperience)")
        }
    }

    private var typesSection: some View {
        Group {
            Text("Tipos")
                .font(.title2)
                .bold()

            HStack(spacing: 12) {
                ForEach(pokemon.types, id: \.type.name) { pokemonType in
                    Text(pokemonType.type.name.capitalized)
                        .typeCapsule(type: pokemonType.type)
                }
            }
        }
    }
}

private struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(self.label)
                .foregroundColor(.secondary)
            Spacer()
            Text(self.value)
                .fontWeight(.semibold)
        }
        .padding(.vertical, 4)
    }
}

protocol TypeColorProviding {
    func color(for type: PokemonType) -> Color
}

struct TypeColorProvider: TypeColorProviding {
    func color(for type: PokemonType) -> Color {
        type.typeEnum.color
    }
}

struct TypeCapsuleModifier: ViewModifier {
    let type: PokemonType
    let colorProvider: TypeColorProviding

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Capsule().fill(colorProvider.color(for: type)))
            .font(.footnote)
            .foregroundColor(.white)
            .bold()
            .shadow(color: colorProvider.color(for: type).opacity(0.4), radius: 3)
    }
}
