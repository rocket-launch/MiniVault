//
//  MVGalleryViewController.swift
//  MiniVault
//
//  Created by Fabián Ferreira on 2022-01-03.
//

import UIKit

class MVGalleryViewController: UICollectionViewController {
    
    var imageURLs = [String]()
    var images = [UIImage?]()
    var page = 1

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
            imageURLs += try await NetworkManager.shared.fetchImageURLs(for: page)
        } catch {
            print(error)
        }
    }
    
    func setBackgroundNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(close), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    func configureCollectionView() {
        collectionView.register(MVPhotoCollectionViewCell.self, forCellWithReuseIdentifier: MVPhotoCollectionViewCell.reuseID)
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
        return imageURLs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MVPhotoCollectionViewCell.reuseID, for: indexPath) as? MVPhotoCollectionViewCell else {
            preconditionFailure("Couldn't retrieve cell of type \(MVPhotoCollectionViewCell.self)")
        }
        cell.setImage(for: imageURLs[indexPath.item])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoDetailVC = MVPhotoDetailViewController()
        Task {
            photoDetailVC.imageURL = imageURLs[indexPath.item]
            photoDetailVC.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(photoDetailVC, animated: true)
        }
    }
}

extension MVGalleryViewController {
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        #warning("Check and re-implement logic.")
        if offsetY > (contentHeight - height * 1.5) {
            page += 1
            Task {
                await fetchImages(for: page)
                collectionView.reloadData()
            }
        }
    }
}
