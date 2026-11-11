//
//  PokemonImageView.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 22/02/25.
//

import SwiftUI

enum PokemonImageStyle: String {
    /// Sprite pequeno, usado no grid da lista.
    case sprite
    /// Artwork oficial em alta resolução, usado nos detalhes.
    case artwork

    var baseURL: String {
        switch self {
        case .sprite: ApiUrls.spriteUrl
        case .artwork: ApiUrls.artworkUrl
        }
    }
}

struct PokemonImageView: View {
    let pokemonId: Int
    let style: PokemonImageStyle
    var dominantColor: Binding<Color>?

    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "photo")
                    .foregroundStyle(.tertiary)
            }
        }
        .task(id: "\(style.rawValue)-\(pokemonId)") {
            await loadImage()
        }
    }

    private func loadImage() async {
        if let cached = PokemonImageCache.shared.image(forKey: cacheKey) {
            image = cached
            updateDominantColor(of: cached)
            return
        }

        guard let url = URL(string: cacheKey) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let downloadedImage = UIImage(data: data) else { return }
            PokemonImageCache.shared.setImage(downloadedImage, forKey: cacheKey)
            image = downloadedImage
            updateDominantColor(of: downloadedImage)
        } catch is CancellationError {
            // Download cancelado: ignora silenciosamente.
        } catch {
            // Sem imagem: mantém o placeholder.
        }
    }

    private var cacheKey: String {
        "\(style.baseURL)\(pokemonId).png"
    }

    private func updateDominantColor(of image: UIImage) {
        guard let binding = dominantColor else { return }
        let uiColor = image.dominantColor ?? .clear
        binding.wrappedValue = Color(uiColor)
    }
}
