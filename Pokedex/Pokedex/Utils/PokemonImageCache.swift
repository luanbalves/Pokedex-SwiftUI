//
//  PokemonImageCache.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 22/02/25.
//

import UIKit

/// Cache de imagens em dois níveis:
/// - Memória (`NSCache`) para acesso imediato durante a sessão;
/// - Disco (`FileManager`, pasta de caches) para reaproveitar
///   imagens entre sessões sem refazer download.
final class PokemonImageCache: @unchecked Sendable {
    static let shared = PokemonImageCache()

    private let memoryCache = NSCache<NSString, UIImage>()
    private let diskDirectory: URL

    private init(directoryName: String = "PokemonImages") {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        diskDirectory = caches.appending(path: directoryName)
        try? FileManager.default.createDirectory(at: diskDirectory, withIntermediateDirectories: true)

        memoryCache.countLimit = 200
    }

    func image(forKey key: String) -> UIImage? {
        if let cached = memoryCache.object(forKey: key as NSString) {
            return cached
        }

        guard let data = try? Data(contentsOf: diskFileURL(forKey: key)) else { return nil }
        let image = UIImage(data: data)
        if let image {
            memoryCache.setObject(image, forKey: key as NSString)
        }
        return image
    }

    func setImage(_ image: UIImage, forKey key: String) {
        memoryCache.setObject(image, forKey: key as NSString)
        try? image.pngData()?.write(to: diskFileURL(forKey: key), options: .atomic)
    }

    private func diskFileURL(forKey key: String) -> URL {
        let fileName = Data(key.utf8).base64EncodedString()
        return diskDirectory.appending(path: fileName)
    }
}
