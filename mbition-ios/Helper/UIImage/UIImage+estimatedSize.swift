//
//  UIImage+estimatedSize.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 08.12.22.
//

import UIKit

extension UIImage {
    static func estimatedSize(_ image: UIImage) -> Int {
        guard let cgImage = image.cgImage else { return 0 }
        return cgImage.bytesPerRow * cgImage.height
    }
}
