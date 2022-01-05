//
//  MVGalleryViewController.swift
//  MiniVault
//
//  Created by Fabián Ferreira on 2022-01-03.
//

import UIKit

class MVGalleryViewController: UICollectionViewController {
    
    var imageURLs = [String]()
    var images = [UIImage]()
    var page = 1
    var isLoadingPage = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        setBackgroundNotification()
        
        Task {
            await fetchImages(for: page)
            collectionView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    func fetchImages(for page: Int) async {
        do {
            imageURLs = try await NetworkManager.shared.fetchImageURLs(for: page)
            for imageURL in imageURLs {
                if let image = try? await NetworkManager.shared.downloadImage(from: imageURL) {
                    images.append(image)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func setBackgroundNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(close), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    func configureCollectionView() {
        collectionView.register(MVGalleryCollectionViewCell.self, forCellWithReuseIdentifier: MVGalleryCollectionViewCell.reuseID)
        collectionView.setCollectionViewLayout(UILayout.createThreeColumnFlowLayout(in: self.view), animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        modalTransitionStyle = .crossDissolve
        title = "Gallery"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
}

extension MVGalleryViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MVGalleryCollectionViewCell.reuseID, for: indexPath) as? MVGalleryCollectionViewCell else {
            preconditionFailure("Couldn't retrieve cell of type \(MVGalleryCollectionViewCell.self)")
        }
        cell.setImage(for: images[indexPath.item])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoDetailVC = MVPhotoDetailViewController()
        photoDetailVC.images = images
        photoDetailVC.indexPath = indexPath
        photoDetailVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(photoDetailVC, animated: true)
    }
}

extension MVGalleryViewController {
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        #warning("Check and re-implement scroll to bottom logic.")
        if offsetY > (contentHeight - height * 1.5), !isLoadingPage {
            page += 1
            isLoadingPage = true
            Task {
                await fetchImages(for: page)
                collectionView.reloadData()
                isLoadingPage = false
            }
        }
    }
}
