//
//  ViewController.swift
//  MiniVault
//
//  Created by Fabián Ferreira on 2022-01-02.
//

import UIKit

class MVPINViewController: UIViewController {
    
    private var password = "2130"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let pinpad = MVPinPad(frame: .zero)
        pinpad.delegate = self
        view.addSubview(pinpad)
        
        NSLayoutConstraint.activate([
            pinpad.topAnchor.constraint(lessThanOrEqualTo: view.centerYAnchor, constant: -90),
            pinpad.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            pinpad.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            pinpad.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}

extension MVPINViewController: MVPinPadDelegate {
    func validatePassword(_ password: String) {
        if self.password == password {
            print("We're in!!!")
        }
    }
}
