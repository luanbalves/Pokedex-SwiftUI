//
//  Extracters.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 21/02/25.
//

import SwiftUI

class Extracters {
    static func extractPokemonId(from url: String) -> String? {
        let components = url.split(separator: "/")
        return components.last.map { String($0) }
    }
}
