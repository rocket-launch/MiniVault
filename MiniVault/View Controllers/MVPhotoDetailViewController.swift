//
//  MVPhotoDetailViewController.swift
//  MiniVault
//
//  Created by Fabián Ferreira on 2022-01-03.
//

import UIKit

class MVPhotoDetailViewController: UIViewController {

    var images: [UIImage]!
    var indexPath: IndexPath!
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UILayout.createSingleColumnFlowLayout(in: self.view))
        collectionView.register(MVPhotoCollectionViewCell.self, forCellWithReuseIdentifier: MVPhotoCollectionViewCell.reuseID)
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        scrollToItem(at: indexPath)
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.hidesBarsOnTap = true
    }
    
    func configureCollectionView() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func scrollToItem(at indexPath: IndexPath) {
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
    }
}

extension MVPhotoDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MVPhotoCollectionViewCell.reuseID, for: indexPath) as? MVPhotoCollectionViewCell else {
            preconditionFailure()
        }
        
        cell.setImage(for: images[indexPath.item])
        return cell
    }
}

extension MVPhotoDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
