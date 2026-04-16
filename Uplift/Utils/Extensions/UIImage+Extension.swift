//
//  UIImage+Extension.swift
//  Uplift
//
//  Created by Caitlyn Jin on 4/15/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import UIKit

extension UIImage {

    func resized(maxDimension: CGFloat = 300) -> UIImage {
        let size = self.size

        guard size.width > 0, size.height > 0 else { return self }

        let maxSide = max(size.width, size.height)
        guard maxSide > maxDimension else { return self }

        let aspectRatio = size.width / size.height
        var newSize: CGSize

        if size.width > size.height {
            newSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
        } else {
            newSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
        }

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

}
