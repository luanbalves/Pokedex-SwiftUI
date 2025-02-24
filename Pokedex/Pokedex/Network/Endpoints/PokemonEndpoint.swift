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
            return "/api/v2/pokemon/"
        case .getPokemonDetails(id: let id):
            return "/api/v2/pokemon/\(id)"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .getAllPokemons, .getPokemonDetails:
            .get
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .getAllPokemons, .getPokemonDetails:
            return ["Content-Type": "application/json"]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getAllPokemons(let offset, let limit):
            if let offset = offset {
                return [URLQueryItem(name: "offset", value: String(offset))]
            }
            
            if let limit = limit {
                return [URLQueryItem(name: "limit", value: String(limit))]
            }
            
            return nil
        case .getPokemonDetails:
            return nil
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .getAllPokemons:
            return nil
        case .getPokemonDetails:
            return nil
        }
    }
}
