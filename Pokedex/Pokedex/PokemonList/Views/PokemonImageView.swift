//
//  PokemonImageView.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 22/02/25.
//

import SwiftUI

struct PokemonImageView: View {
    let url: URL?
    let placeholder: Image

    @State private var image: UIImage?
    @Binding var dominantColor: Color

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .background(
                        GeometryReader { _ in
                            Color.clear
                                .task(id: image) {
                                    let uiColor = image.dominantColor ?? .clear
                                    self.dominantColor = Color(uiColor)
                                }
                        }
                    )
                    .cornerRadius(10)
            } else {
                self.placeholder
                    .onAppear {
                        self.loadImage()
                    }
            }
        }
    }

    private func loadImage() {
        guard let url = url else { return }

        if let cachedImage = ImageCache.getImage(forKey: url.absoluteString) {
            self.image = cachedImage
            return
        }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let downloadedImage = UIImage(data: data) {
                    ImageCache.setImage(downloadedImage, forKey: url.absoluteString)
                    DispatchQueue.main.async {
                        self.image = downloadedImage
                    }
                }
            } catch {
                print("Error downloading image: \(error.localizedDescription)")
            }
        }
    }
}
