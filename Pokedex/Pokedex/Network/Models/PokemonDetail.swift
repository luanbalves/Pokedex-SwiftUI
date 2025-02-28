//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 22/02/25.
//

import SwiftUI

struct PokemonDetail: Decodable, Identifiable {
    var id: Int
    var name: String
    var baseExperience: Int
    var height: Int
    var weight: Int
    var types: [PokemonTypes]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case baseExperience = "base_experience"
        case height
        case weight
        case types
    }
}

struct PokemonTypes: Decodable {
    var slot: Int
    var type: PokemonType
}

struct PokemonType: Decodable {
    var name: String
    var url: String
    
    var typeEnum: PokemonTypeEnum {
        PokemonTypeEnum(rawValue: name)
    }
}

extension PokemonType {
    enum PokemonTypeEnum: String, CaseIterable {
        case fire, water, grass, electric, psychic, poison, ground
        case flying, bug, normal, fighting, rock, ghost, ice
        case dragon, dark, steel, fairy, unknown
        
        var color: Color {
            switch self {
            case .fire: return .orange
            case .water: return .blue
            case .grass: return .green
            case .electric: return .yellow
            case .psychic: return .pink
            case .poison: return .purple
            case .ground: return .brown
            case .flying: return .cyan
            case .bug: return Color(red: 0.451, green: 0.624, blue: 0.243)
            case .normal: return .gray
            case .fighting: return .red
            case .rock: return Color(red: 0.67, green: 0.63, blue: 0.47)
            case .ghost: return Color(red: 0.29, green: 0.21, blue: 0.38)
            case .ice: return .teal
            case .dragon: return Color(red: 0.44, green: 0.21, blue: 0.93)
            case .dark: return .black
            case .steel: return Color(red: 0.72, green: 0.72, blue: 0.81)
            case .fairy: return .pink.opacity(0.7)
            case .unknown: return .gray
            }
        }
        
        init(rawValue: String) {
            let lowercased = rawValue.lowercased()
            self = PokemonTypeEnum.allCases.first { $0.rawValue == lowercased } ?? .unknown
        }
    }
}
