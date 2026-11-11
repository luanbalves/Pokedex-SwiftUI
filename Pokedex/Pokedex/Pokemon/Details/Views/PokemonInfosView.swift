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

    private var typeColor: Color {
        pokemon.types.first?.type.typeEnum.color ?? .blue
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(pokemon.name.capitalized)
                .font(.largeTitle)
                .padding(.top, 20)

            infoSection
            typesSection
            statsSection
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .offset(y: -40)
    }

    private var infoSection: some View {
        Group {
            Text("details.info")
                .font(.title2)
                .bold()

            InfoRow(label: String(localized: "details.height"), value: meters)
            InfoRow(label: String(localized: "details.weight"), value: kilograms)
            InfoRow(label: String(localized: "details.experience"), value: "\(pokemon.baseExperience)")
        }
    }

    /// A API retorna altura em decímetros e peso em hectogramas.
    private var meters: String {
        String(format: "%.1f m", Double(pokemon.height) / 10)
    }

    private var kilograms: String {
        String(format: "%.1f kg", Double(pokemon.weight) / 10)
    }

    private var typesSection: some View {
        Group {
            Text("details.types")
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

    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("details.stats")
                .font(.title2)
                .bold()

            ForEach(pokemon.stats, id: \.stat.name) { stat in
                StatBar(
                    label: Self.label(for: stat.stat.name),
                    value: stat.baseStat,
                    color: typeColor
                )
            }
        }
    }

    private static func label(for rawStatName: String) -> String {
        switch rawStatName {
        case "hp": String(localized: "stats.hp")
        case "attack": String(localized: "stats.attack")
        case "defense": String(localized: "stats.defense")
        case "special-attack": String(localized: "stats.specialAttack")
        case "special-defense": String(localized: "stats.specialDefense")
        case "speed": String(localized: "stats.speed")
        default: rawStatName.capitalized
        }
    }
}

private struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
        .padding(.vertical, 4)
    }
}

/// Barra de atributo com escala máxima de 255 (maior base_stat da Pokédex).
private struct StatBar: View {
    let label: String
    let value: Int
    let color: Color

    private static let maxValue: CGFloat = 255

    var body: some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.subheadline)
                .frame(width: 116, alignment: .leading)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.quaternary)
                    Capsule()
                        .fill(color)
                        .frame(width: geometry.size.width * min(CGFloat(value) / Self.maxValue, 1))
                }
            }
            .frame(height: 10)

            Text("\(value)")
                .font(.subheadline.monospacedDigit())
                .frame(width: 32, alignment: .trailing)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label): \(value)")
    }
}
