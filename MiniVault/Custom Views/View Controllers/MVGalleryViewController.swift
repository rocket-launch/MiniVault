//
//  MVGalleryViewController.swift
//  MiniVault
//
//  Created by Fabián Ferreira on 2022-01-03.
//

import UIKit

class MVGalleryViewController: UICollectionViewController {
    
    var imageURLs = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        
        Task {
            do {
                imageURLs = try await NetworkManager.shared.fetchImageURLs(for: 3)
                print(imageURLs)
                collectionView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func configureCollectionView() {
        collectionView.register(MVPhotoCollectionViewCell.self, forCellWithReuseIdentifier: MVPhotoCollectionViewCell.reuseID)
        collectionView.setCollectionViewLayout(UILayout.createThreeColumnFlowLayout(in: self.view), animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Gallery"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
}

extension MVGalleryViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MVPhotoCollectionViewCell.reuseID, for: indexPath) as? MVPhotoCollectionViewCell else {
            preconditionFailure("Couldn't retrieve cell of type \(MVPhotoCollectionViewCell.self)")
        }
        cell.setImage(for: imageURLs[indexPath.item])
        return cell
    }
}
