//
//  UIImage+Extensions.swift
//  Pokedex
//
//  Created by Luan Alves Barroso on 24/02/25.
//

import SwiftUI

extension UIImage {
    var dominantColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        
        let processedImage = inputImage
            .applyingFilter("CIColorControls", parameters: [
                kCIInputSaturationKey: 1.8,
                kCIInputContrastKey: 1.4
            ])
            .applyingFilter("CIColorClamp", parameters: [
                "inputMinComponents": CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.0),
                "inputMaxComponents": CIVector(x: 0.9, y: 0.9, z: 0.9, w: 1.0)
            ])

        let edgePercentage: CGFloat = 0.3
        let size = processedImage.extent.size
        let cropSize = CGSize(
            width: size.width * (1 - 2 * edgePercentage),
            height: size.height * (1 - 2 * edgePercentage)
        )
        let cropRect = CGRect(
            origin: CGPoint(
                x: size.width * edgePercentage,
                y: size.height * edgePercentage
            ),
            size: cropSize
        )
        
        guard let filter = CIFilter(
            name: "CIAreaAverage",
            parameters: [
                kCIInputImageKey: processedImage.cropped(to: cropRect),
                kCIInputExtentKey: CIVector(cgRect: cropRect)
            ]
        ), let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [
            .workingColorSpace: CGColorSpaceCreateDeviceRGB(),
            .highQualityDownsample: true
        ])
        
        context.render(
            outputImage,
            toBitmap: &bitmap,
            rowBytes: 4,
            bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
            format: .RGBA8,
            colorSpace: nil
        )
        
        let red = CGFloat(bitmap[0]) / 255
        let green = CGFloat(bitmap[1]) / 255
        let blue = CGFloat(bitmap[2]) / 255
        
        let brightness = (red + green + blue) / 3
        let factor: CGFloat = brightness < 0.2 ? 1.5 : 1.0
        
        return UIColor(
            red: min(red * factor, 1.0),
            green: min(green * factor, 1.0),
            blue: min(blue * factor, 1.0),
            alpha: 1.0
        )
    }
}
