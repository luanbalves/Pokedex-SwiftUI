//
//  ImageCache.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 22/02/25.
//


import SwiftUI

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()

    static func getImage(forKey key: String) -> UIImage? {
        return shared.object(forKey: key as NSString)
    }

    static func setImage(_ image: UIImage, forKey key: String) {
        shared.setObject(image, forKey: key as NSString)
    }
}
