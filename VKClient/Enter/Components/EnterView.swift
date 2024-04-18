//
//  EnterView.swift
//  VKClient
//
//  Created by Павел on 12.04.2024.
//

import UIKit

protocol EnterViewProtocol: AnyObject {
    func animatedViewSetup()
}

class EnterView: UIView {
    //MARK: - Property
    var presenter: EnterPresenterProtocol?
    private lazy var loginTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Телефон или почта")
        textField.alpha = 0
        return textField
    }()
    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Пароль", isSecureText: true)
        textField.alpha = 0
        return textField
    }()
    private lazy var runButton: UIButton = {
        let button = UIButton()
        button.alpha = 0
        button.backgroundColor = .vkBlue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitle("Войти", for: .normal)
        button.addTarget(self, action: #selector(runButtonPressed(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(runButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.vkBlue
        return indicator
    }()
    
    //MARK: - Constraint property
    private lazy var loginTextFieldYPositionConstraint: NSLayoutConstraint = {
        loginTextField.bottomAnchor.constraint(equalTo: topAnchor)
    }()
    private lazy var passwordTextFieldYPositionConstraint: NSLayoutConstraint = {
        loginTextField.topAnchor.constraint(equalTo: loginTextField.topAnchor)
    }()
    private lazy var runButtonYPositionConstraint: NSLayoutConstraint = {
        runButton.topAnchor.constraint(equalTo: passwordTextField.topAnchor)
    }()
    
    //MARK: - Init
    init() {
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private functions
private extension EnterView {
    func initialize() {
        setupViews()
        setupLayout()
    }
    
    func setupViews() {
        backgroundColor = .vkWhite
    }
    
    func setupLayout() {
        addSubview(runButton)
        addSubview(passwordTextField)
        addSubview(loginTextField)
        addSubview(activityIndicator)
        
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        runButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            loginTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            loginTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            loginTextFieldYPositionConstraint,
            
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            passwordTextFieldYPositionConstraint,
            
            runButton.heightAnchor.constraint(equalToConstant: 44),
            runButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            runButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            runButtonYPositionConstraint,
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: runButton.bottomAnchor, constant: 10),
        ])
    }
    
    @objc func runButtonAction(_ sender: UIButton) {
        sender.alpha = 1.0
        
        if areAllFieldsFilled() {
            activityIndicator.startAnimating()
            VKService().signIn(login: loginTextField.getText(),
                                   password: passwordTextField.getText()) { bool, error in
                if bool {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                    self.presenter?.signInSuccesfull()
                } else {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                    guard let error else { return }
                    self.presenter?.errorCaught(errorMessage: error)
                }
            }
        }
    }
    
    @objc func runButtonPressed(_ sender: UIButton) {
        sender.alpha = 0.5
    }
    
    func areAllFieldsFilled() -> Bool {
        let textFields = [loginTextField, passwordTextField]
        var allFieldsFilled = true
        
        for textField in textFields {
            if !textField.isTextFieldFilled() {
                allFieldsFilled = false
                textField.errorAnimation()
                break
            }
        }
        
        return allFieldsFilled
    }
}

//MARK: - Animations
private extension EnterView {
    func passwordViewAppearanceAnimation(completion: @escaping () -> Void) {
        self.layoutIfNeeded()
        NSLayoutConstraint.deactivate([
            self.passwordTextFieldYPositionConstraint
        ])
        passwordTextFieldYPositionConstraint = passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 24)
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            NSLayoutConstraint.activate([
                self.passwordTextFieldYPositionConstraint,
            ])
            self.passwordTextField.alpha = 1
            self.layoutIfNeeded()
        },
                       completion: { _ in
            completion()
        })
    }
    
    func loginTextFieldAppearanceAnimation() {
        self.layoutIfNeeded()
        NSLayoutConstraint.deactivate([
            self.loginTextFieldYPositionConstraint,
        ])
        loginTextFieldYPositionConstraint = loginTextField.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.9,
                       options: .curveEaseOut,
                       animations: {
            NSLayoutConstraint.activate([
                self.loginTextFieldYPositionConstraint,
            ])
            self.loginTextField.alpha = 1
            self.layoutIfNeeded()
        })
    }
    
    func passwordTextFieldAppearanceAnimation() {
        self.layoutIfNeeded()
        NSLayoutConstraint.deactivate([
            self.passwordTextFieldYPositionConstraint,
        ])
        passwordTextFieldYPositionConstraint = passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor,
                                                                                      constant: 16)
        UIView.animate(withDuration: 0.2,
                       delay: 0.1,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.9,
                       options: .curveEaseOut,
                       animations: {
            NSLayoutConstraint.activate([
                self.passwordTextFieldYPositionConstraint,
            ])
            self.passwordTextField.alpha = 1
            self.layoutIfNeeded()
        })
    }
    
    func runButtonAppearanceAnimation() {
        self.layoutIfNeeded()
        NSLayoutConstraint.deactivate([
            self.runButtonYPositionConstraint,
        ])
        runButtonYPositionConstraint = runButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,
                                                                      constant: 16)
        UIView.animate(withDuration: 0.2,
                       delay: 0.2,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.9,
                       options: .curveEaseOut,
                       animations: {
            NSLayoutConstraint.activate([
                self.runButtonYPositionConstraint,
            ])
            self.runButton.alpha = 1
            self.layoutIfNeeded()
        })
    }
}

//MARK: - EnterViewProtocol
extension EnterView: EnterViewProtocol {
    func animatedViewSetup() {
        self.loginTextFieldAppearanceAnimation()
        self.passwordTextFieldAppearanceAnimation()
        self.runButtonAppearanceAnimation()
    }
}
