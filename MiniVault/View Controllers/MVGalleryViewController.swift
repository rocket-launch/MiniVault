//
//  MVGalleryViewController.swift
//  MiniVault
//
//  Created by Fabián Ferreira on 2022-01-03.
//

import UIKit

final class MVGalleryViewController: UICollectionViewController {
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    
    private var imageURLs = [String]()
    private var photos = [Photo]()
    
    private var page = 1
    private var isLoadingPage = false
    
    private var galleryCellRegistration: UICollectionView.CellRegistration<MVGalleryCollectionViewCell, Photo>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureDataSource()
        setBackgroundNotification()
        
        Task {
            await fetchImages(for: page)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    private func fetchImages(for page: Int) async {
        do {
            imageURLs = try await NetworkManager.shared.fetchImageURLs(for: page)
            for imageURL in imageURLs {
                photos.append(Photo(imageURL: imageURL))
            }
            updateData()
        } catch {
            print(error)
        }
    }
    
    private func registerGalleryCell() {
        galleryCellRegistration =  UICollectionView.CellRegistration<MVGalleryCollectionViewCell, Photo> { cell, indexPath, photo in
            Task {
                if let image = await photo.downloadImage() {
                    cell.setImage(with: image)
                } else {
                    self.photos.remove(at: indexPath.item)
                    self.updateData()
                }
            }
        }
    }
        
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: collectionView, cellProvider: { collectionView, indexPath, photo in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.galleryCellRegistration, for: indexPath, item: photo)
            return cell
        })
    }
    
    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos, toSection: .main)
        DispatchQueue.main.async {
            self.dataSource.applySnapshotUsingReloadData(snapshot)
        }
        
    }
    
    private func configureCollectionView() {
        collectionView.setCollectionViewLayout(UILayout.createThreeColumnFlowLayout(in: self.view), animated: true)
        collectionView.delegate = self
        registerGalleryCell()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        modalTransitionStyle = .crossDissolve
        title = "Gallery"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
    
    private func setBackgroundNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(close), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
}

extension MVGalleryViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoDetailVC = MVPhotoDetailViewController()
        photoDetailVC.photos = photos
        photoDetailVC.indexPath = indexPath
        photoDetailVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(photoDetailVC, animated: true)
    }
}

extension MVGalleryViewController {
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let height = scrollView.frame.height
        
        let contentHeight = scrollView.contentSize.height
    
        if (offsetY + height) > contentHeight, !isLoadingPage {
            page += 1
            isLoadingPage = true
            Task {
                await fetchImages(for: page)
                isLoadingPage = false
            }
        }
    }
}
