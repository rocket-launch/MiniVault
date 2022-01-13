//
//  MVPinPad.swift
//  MiniVault
//
//  Created by Fabián Ferreira on 2022-01-03.
//

import UIKit

protocol MVPinPadDelegate: AnyObject {
    func validatePassword(_ password: String) -> Bool
}

final class MVPinPad: UIView {
    
    private enum numbers: Int, CaseIterable {
        case zero = 0, one, two, three, four, five, six, seven, eight, nine, delete
    }
    
    private let color: UIColor = {
        return [.systemPink, .systemYellow, .systemBlue, .systemRed, .systemGreen].randomElement() ?? UIColor.systemBlue
    }()
    
    lazy private var passwordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        textField.minimumFontSize = 20
        textField.textAlignment = .center
        textField.textColor = color
        textField.isSecureTextEntry = true
        textField.adjustsFontSizeToFitWidth = true
        return textField
    }()
    
    lazy private var keys: [MVKey] = {
        var numericKey = [MVKey]()
        for number in numbers.allCases {
            let key = number.rawValue < 10 ? MVKey(keyText: String(describing: number.rawValue), color: color) : MVKey(keyImage: UIImage(systemName: "delete.left"), color: color)
            key.tag = number.rawValue
            key.delegate = self
            numericKey.append(key)
        }
        return numericKey
    }()
    
    lazy private var keyPadRowsStack: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .trailing
        return stackView
    }()
    
    weak var delegate: MVPinPadDelegate?
    
    private var enteredPassword = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        addSubview(passwordTextField)
        addSubview(keyPadRowsStack)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        for row in 1...4 {
            let keyPadColumnStack = UIStackView(frame: .zero)
            keyPadColumnStack.translatesAutoresizingMaskIntoConstraints = false
            keyPadColumnStack.axis = .horizontal
            keyPadColumnStack.distribution = .equalSpacing
            keyPadColumnStack.spacing = 15
            
            switch row {
            case 1:
                keyPadColumnStack.addArrangedSubviews(Array<MVKey>(keys[1...3]))
            case 2:
                keyPadColumnStack.addArrangedSubviews(Array<MVKey>(keys[4...6]))
            case 3:
                keyPadColumnStack.addArrangedSubviews(Array<MVKey>(keys[7...9]))
            case 4:
                keyPadColumnStack.addArrangedSubviews([keys[0], keys[10]])
            default:
                break
            }
            keyPadRowsStack.addArrangedSubview(keyPadColumnStack)
        }
        
        NSLayoutConstraint.activate([
            keyPadRowsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            keyPadRowsStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            keyPadRowsStack.heightAnchor.constraint(equalToConstant: 350),
            keyPadRowsStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            passwordTextField.bottomAnchor.constraint(equalTo: keyPadRowsStack.topAnchor, constant: -100),
            passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 80),
            passwordTextField.widthAnchor.constraint(equalToConstant: 300),
        ])
        
    }
}

extension MVPinPad: MVKeyDelegate {
    func keyTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0...9:
            guard let tappedNumber = sender.titleLabel?.text else { return }
            passwordTextField.text?.append(tappedNumber)
            enteredPassword += tappedNumber
        default:
            guard let password = passwordTextField.text, !password.isEmpty else { return }
            passwordTextField.text?.removeLast()
            enteredPassword.removeLast()
        }
        
        if let isPassword = delegate?.validatePassword(enteredPassword), isPassword {
            passwordTextField.text = ""
            enteredPassword = ""
        }
    }
}


