//
//  MVKey.swift
//  MiniVault
//
//  Created by Fabián Ferreira on 2022-01-02.
//

import UIKit

protocol MVKeyDelegate: AnyObject {
    func keyTapped(_ sender: UIButton)
}

class MVKey: UIButton {
    
    var keyText: AttributedString?
    var keyImage: UIImage?
    
    weak var delegate: MVKeyDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(keyText: String) {
        self.init(frame: .zero)
        self.keyText = AttributedString(keyText, attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 25, weight: .medium)]))
        configure()
    }
    
    convenience init(keyImage: UIImage?) {
        self.init(frame: .zero)
        self.keyImage = keyImage
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        configuration = .tinted()
        configuration?.cornerStyle = .capsule
        configuration?.baseBackgroundColor = .systemBlue
        configuration?.baseForegroundColor = .systemBlue
        configuration?.attributedTitle = keyText
        configuration?.image = keyImage
            
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 80),
            self.widthAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
        addTarget(self, action: #selector(keyTapped(_:)), for: .touchUpInside)
    }
    
    @objc func keyTapped(_ sender: UIButton) {
        delegate?.keyTapped(sender)
    }
}