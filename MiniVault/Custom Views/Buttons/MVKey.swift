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

final class MVKey: UIButton {
    
    private var keyText: AttributedString?
    private var keyImage: UIImage?
    private var color: UIColor?
    
    weak var delegate: MVKeyDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(keyText: String, color: UIColor) {
        self.init(frame: .zero)
        self.color = color
        self.keyText = AttributedString(keyText, attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 25, weight: .medium)]))
        configure()
    }
    
    convenience init(keyImage: UIImage?, color: UIColor) {
        self.init(frame: .zero)
        self.color = color
        self.keyImage = keyImage
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        configuration = .tinted()
        configuration?.cornerStyle = .capsule
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
        configuration?.attributedTitle = keyText
        configuration?.image = keyImage
            
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 80),
            self.widthAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
        addTarget(self, action: #selector(keyTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func keyTapped(_ sender: UIButton) {
        delegate?.keyTapped(sender)
    }
}
