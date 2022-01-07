//
//  Photo.swift
//  MiniVault
//
//  Created by Fabián Ferreira on 2022-01-06.
//

import UIKit

class Photo: Hashable {
    
    let imageURL: String
    var imageData: UIImage?
    
    init(imageURL: String) {
        self.imageURL = imageURL
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(imageURL)
    }
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.imageURL == rhs.imageURL
    }
    
    func setImage(to image: UIImage) {
        self.imageData = image
    }
    
    func setImage(for photo: Photo) async {
        do {
            let image = try await NetworkManager.shared.downloadImage(from: photo.imageURL)
            photo.imageData = image
        } catch {
            print(error)
        }
        
    }
}
