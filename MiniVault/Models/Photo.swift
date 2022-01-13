//
//  Photo.swift
//  MiniVault
//
//  Created by Fabián Ferreira on 2022-01-06.
//

import UIKit

final class Photo: Hashable {
    
    private let imageURL: String
    
    init(imageURL: String) {
        self.imageURL = imageURL
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(imageURL)
    }
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.imageURL == rhs.imageURL
    }
    
    func downloadImage() async -> UIImage? {
        return try? await NetworkManager.shared.downloadImage(from: imageURL)
    }
}
