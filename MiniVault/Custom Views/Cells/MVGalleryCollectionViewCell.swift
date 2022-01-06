//
//  MVGalleryCollectionViewCell.swift
//  MiniVault
//
//  Created by Fabián Ferreira on 2022-01-03.
//

import UIKit

class MVGalleryCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "GalleryCell"
    var photoImageView = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(for image: UIImage?) {
        if let image = image {
            photoImageView.image = image
        }
    }
    
    func setImage(for image: String) {
        Task {
            do {
                let image = try await NetworkManager.shared.downloadImage(from: image)
                photoImageView.image = image
            } catch {
                print(error)
            }
        }
    }
    
    func configure() {
        contentView.addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        // This just looks better than .scaleToFill
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
