//
//  PokemonEndpoint.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 20/02/25.
//

import Foundation

enum PokemonEndpoint {
    case getAllPokemons(offset: Int?, limit: Int?)
    case getPokemonDetails(id: Int)
}

extension PokemonEndpoint: Endpoint {

    var path: String {
        switch self {
        case .getAllPokemons:
            "/api/v2/pokemon/"
        case .getPokemonDetails(let id):
            "/api/v2/pokemon/\(id)"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getAllPokemons, .getPokemonDetails:
            .get
        }
    }

    /// Envia `offset` **e** `limit` juntos quando presentes.
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getAllPokemons(let offset, let limit):
            var items: [URLQueryItem] = []
            if let offset {
                items.append(URLQueryItem(name: "offset", value: String(offset)))
            }
            if let limit {
                items.append(URLQueryItem(name: "limit", value: String(limit)))
            }
            return items.isEmpty ? nil : items
        case .getPokemonDetails:
            return nil
        }
    }
}
