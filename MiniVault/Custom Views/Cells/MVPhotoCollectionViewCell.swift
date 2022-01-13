//
//  MVPhotoCollectionViewCell.swift
//  MiniVault
//
//  Created by Fabián Ferreira on 2022-01-05.
//

import Foundation
import UIKit

final class MVPhotoCollectionViewCell: UICollectionViewCell {
    
    private var photoImageView = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(for image: UIImage) {
        photoImageView.image = image
    }
    
    private func configure() {
        contentView.addSubview(photoImageView)

        photoImageView.contentMode = .scaleAspectFit
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
