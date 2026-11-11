//
//  View+Extensions.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 26/02/25.
//

import SwiftUI

extension View {
    func typeCapsule(type: PokemonType) -> some View {
        modifier(TypeCapsuleModifier(type: type))
    }
}

struct TypeCapsuleModifier: ViewModifier {
    let type: PokemonType

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Capsule().fill(type.typeEnum.color))
            .font(.footnote)
            .foregroundColor(.white)
            .bold()
            .shadow(color: type.typeEnum.color.opacity(0.4), radius: 3)
    }
}
