//
//  MVPhotoDetailViewController.swift
//  MiniVault
//
//  Created by Fabián Ferreira on 2022-01-03.
//

import UIKit

class MVPhotoDetailViewController: UIViewController {
    
    let imageView = UIImageView()
    var imageURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureImageView()
        
        // Only downloads images that aren't already cached.
        Task {
            imageView.image = try await NetworkManager.shared.downloadImage(from: imageURL)
        }
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.hidesBarsOnTap = true
    }
    func configureImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
