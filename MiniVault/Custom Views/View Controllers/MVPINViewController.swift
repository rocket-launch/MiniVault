//
//  ViewController.swift
//  MiniVault
//
//  Created by Fabián Ferreira on 2022-01-02.
//

import UIKit

class MVPINViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let pinpad = MVPinPad(frame: .zero)
        view.addSubview(pinpad)
        
        NSLayoutConstraint.activate([
            pinpad.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            pinpad.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            pinpad.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            pinpad.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}

