//
//  CustomTextField.swift
//  VKClient
//
//  Created by Павел on 12.04.2024.
//

import UIKit

class CustomTextField: UIView {
    //MARK: - Property
    private let isSecureText: Bool
    private var isTextProtected: Bool = true {
        didSet {
            mainTextField.isSecureTextEntry = isTextProtected
            
            if isTextProtected {
                let image = UIImage(systemName: "eye.fill")?.withRenderingMode(.alwaysTemplate)
                textProtectionButton.setImage(image, for: .normal)
            } else {
                let image = UIImage(systemName: "eye.slash.fill")?.withRenderingMode(.alwaysTemplate)
                textProtectionButton.setImage(image, for: .normal)
            }
        }
    }
    private lazy var mainTextField: UITextField = {
        let textField = UITextField()
        textField.frame = CGRect(x: 0, y: 0, width: 0, height: 44)
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.textColor = .vkGray600
        textField.tintColor = .vkGray600
        textField.backgroundColor = .vkWhite
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.vkGray600.cgColor
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .vkWhite
        label.font = UIFont(name: "Arial", size: 16)
        label.textColor = .vkGray600
        return label
    }()
    private lazy var textProtectionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        let image = UIImage(systemName: "eye.fill")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .vkGray600
        button.addTarget(self, action: #selector(textProtectionToggle(_:)), for: .touchDown)
        return button
    }()
    
    //MARK: - Init
    init(placeholder: String?, isSecureText: Bool = false) {
        self.isSecureText = isSecureText
        super.init(frame: .zero)
        placeholderLabel.text = placeholder?.placeholderFormat()
        setupLayout()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private functions
private extension CustomTextField {
    func setupViews() {
        if isSecureText {
            mainTextField.isSecureTextEntry = isTextProtected
            textProtectionButton.isHidden = false
        } else {
            textProtectionButton.isHidden = true
            mainTextField.clearButtonMode = .whileEditing
        }
    }
    
    func setupLayout() {
        addSubview(mainTextField)
        addSubview(placeholderLabel)
        addSubview(textProtectionButton)
        
        mainTextField.translatesAutoresizingMaskIntoConstraints = false
        textProtectionButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainTextField.topAnchor.constraint(equalTo: topAnchor),
            mainTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainTextField.heightAnchor.constraint(equalToConstant: 44),
            
            textProtectionButton.widthAnchor.constraint(equalToConstant: 30),
            textProtectionButton.heightAnchor.constraint(equalToConstant: 30),
            textProtectionButton.centerYAnchor.constraint(equalTo: mainTextField.centerYAnchor),
            textProtectionButton.trailingAnchor.constraint(equalTo: mainTextField.trailingAnchor, constant: -10),
        ])
        placeholderLabel.frame.size = placeholderLabel.getTextSize()
        placeholderLabel.frame.origin = CGPoint(x: mainTextField.frame.origin.x + 15,
                                                y: mainTextField.frame.midY - placeholderLabel.frame.height / 2)
    }
    
    @objc func textProtectionToggle(_ sender: UIButton) {
        isTextProtected.toggle()
    }
}

//MARK: - Actions
extension CustomTextField {
    func isTextFieldFilled() -> Bool {
        if let text = mainTextField.text, text.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func errorAnimation() {
        errorShakeAnimation()
        mainTextField.errorBorderAnimation()
        placeholderLabel.textErrorAnimation()
    }
    
    func getText() -> String {
        mainTextField.text ?? ""
    }
}

extension CustomTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1) {
            self.placeholderLabel.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.placeholderLabel.frame.origin = CGPoint(x: self.mainTextField.frame.origin.x + 15,
                                                         y: self.mainTextField.frame.minY - self.placeholderLabel.frame.height / 2)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if mainTextField.text == "" {
            UIView.animate(withDuration: 0.1) {
                self.placeholderLabel.transform = .identity
                self.placeholderLabel.frame.origin = CGPoint(x: self.mainTextField.frame.origin.x + 15,
                                                             y: self.mainTextField.frame.midY - self.placeholderLabel.frame.height / 2)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mainTextField.resignFirstResponder()
        return true
    }
}
