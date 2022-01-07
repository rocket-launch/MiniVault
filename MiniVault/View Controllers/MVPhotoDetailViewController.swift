//
//  MVPhotoDetailViewController.swift
//  MiniVault
//
//  Created by Fabián Ferreira on 2022-01-03.
//

import UIKit

class MVPhotoDetailViewController: UIViewController {

    var photos: [Photo]!
    var indexPath: IndexPath!
    var dataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    var photoCellRegistration: UICollectionView.CellRegistration<MVPhotoCollectionViewCell, Photo>!
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UILayout.createSingleColumnFlowLayout(in: self.view))
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureDataSource()
        updateData()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.hidesBarsOnTap = true
    }
    
    func scrollToItem(at indexPath: IndexPath) {

        collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
    }
    
    func configureCollectionView() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        registerPhotoCell()
    }
    
    func registerPhotoCell() {
        photoCellRegistration = UICollectionView.CellRegistration<MVPhotoCollectionViewCell, Photo> { cell, indexPath, photo in
            cell.setImage(for: photo.imageData)
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: collectionView, cellProvider: { collectionView, indexPath, photo in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.photoCellRegistration, for: indexPath, item: photo)
            cell.setImage(for: photo.imageData)
            return cell
        })
    }
    
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos, toSection: .main)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: false)
            self.scrollToItem(at: self.indexPath)
        }
    }
}

extension MVPhotoDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
