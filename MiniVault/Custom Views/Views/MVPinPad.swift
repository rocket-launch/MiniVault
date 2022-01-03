//
//  MVPinPad.swift
//  MiniVault
//
//  Created by Fabián Ferreira on 2022-01-03.
//

import UIKit

protocol MVPinPadDelegate: AnyObject {
    func validatePassword(_ password: String)
}

class MVPinPad: UIView {
    
    enum numbers: Int, CaseIterable {
        case zero = 0, one, two, three, four, five, six, seven, eight, nine
    }
    
    var passwordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.isSecureTextEntry = true
        textField.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        textField.textAlignment = .center
        textField.textColor = .systemBlue
        return textField
    }()
    
    lazy var keys: [MVKey] = {
        var numericKey = [MVKey]()
        for number in numbers.allCases {
            let key = MVKey(keyText: String(describing: number.rawValue))
            key.tag = number.rawValue
            key.delegate = self
            numericKey.append(key)
        }
        return numericKey
    }()
    
    lazy var keyPadRows: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    weak var delegate: MVPinPadDelegate?
    
    var enteredPassword = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        addSubview(passwordTextField)
        addSubview(keyPadRows)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        for row in 1...4 {
            let keyPadColumn = UIStackView(frame: .zero)
            keyPadColumn.translatesAutoresizingMaskIntoConstraints = false
            keyPadColumn.axis = .horizontal
            keyPadColumn.distribution = .equalSpacing
            switch row {
            case 1:
                keyPadColumn.addArrangedSubviews(Array<MVKey>(keys[1...3]))
            case 2:
                keyPadColumn.addArrangedSubviews(Array<MVKey>(keys[4...6]))
            case 3:
                keyPadColumn.addArrangedSubviews(Array<MVKey>(keys[7...9]))
            case 4:
                let empty = MVKey(keyText: "")
                empty.isEnabled = false
                empty.alpha = 0.0
                
                let delete = MVKey(keyImage: UIImage(systemName: "delete.left"))
                delete.tag = -1
                delete.delegate = self
                
                keyPadColumn.addArrangedSubviews([empty, keys[0], delete])
            default:
                break
            }
            keyPadRows.addArrangedSubview(keyPadColumn)
        }
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: topAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 80),
            
            keyPadRows.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            keyPadRows.leadingAnchor.constraint(equalTo: leadingAnchor),
            keyPadRows.trailingAnchor.constraint(equalTo: trailingAnchor),
            keyPadRows.bottomAnchor.constraint(equalTo: bottomAnchor)
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
        }
        
        delegate?.validatePassword(enteredPassword)
    }
}


