//
//  ViewController.swift
//  MiniVault
//
//  Created by Fabián Ferreira on 2022-01-02.
//

import UIKit

class MVPINViewController: UIViewController {
    
    private var password = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configurePinPad()
    }
    
    func configurePinPad() {
        let pinpad = MVPinPad(frame: .zero)
        pinpad.delegate = self
        view.addSubview(pinpad)
        
        NSLayoutConstraint.activate([
            pinpad.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pinpad.topAnchor.constraint(equalTo: view.topAnchor),
            pinpad.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 10),
            pinpad.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10),
            pinpad.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}

extension MVPINViewController: MVPinPadDelegate {
    func validatePassword(_ password: String) -> Bool {
        if self.password == password {
            let gallery = MVGalleryViewController(collectionViewLayout: UICollectionViewLayout())
                                                  
            let navBar = UINavigationController(rootViewController: gallery)
            navBar.modalPresentationStyle = .fullScreen
            present(navBar, animated: true)
            
            return true
        }
        return false
    }
}
