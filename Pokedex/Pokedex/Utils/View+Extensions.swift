//
//  View+Extensions.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 26/02/25.
//

import SwiftUI

extension View {
    func typeCapsule(type: PokemonType, colorProvider: TypeColorProviding = TypeColorProvider()) -> some View {
        modifier(TypeCapsuleModifier(type: type, colorProvider: colorProvider))
    }
}
