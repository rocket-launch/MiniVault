//
//  MVPhotoCollectionViewCell.swift
//  MiniVault
//
//  Created by Fabián Ferreira on 2022-01-03.
//

import UIKit

class MVPhotoCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "PhotoCell"
    var photoImageView = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        // This just looks better than .scaleToFill
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
