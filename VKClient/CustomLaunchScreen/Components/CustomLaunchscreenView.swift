//
//  CustomLaunchscreenView.swift
//  VKClient
//
//  Created by Павел on 15.04.2024.
//

import UIKit

protocol CustomLaunchscreenViewProtocol: AnyObject {
    func animateLogoView()
}

class CustomLaunchscreenView: UIView {
    //MARK: - Property
    var presenter: CustomLaunchscreenPresenterProtocol?
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0
        imageView.backgroundColor = .clear
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        let image = UIImage(named: "VK_Logo")
        imageView.image = image
        return imageView
    }()

    //MARK: - Constraint property
    private lazy var logoWidthConstraint: NSLayoutConstraint = {
        logoImageView.widthAnchor.constraint(equalToConstant: 100)
    }()
    private lazy var logoHeightConstraint: NSLayoutConstraint = {
        logoImageView.heightAnchor.constraint(equalToConstant: 100)
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
private extension CustomLaunchscreenView {
    func initialize() {
        setupViews()
        setupLayout()
    }
    
    func setupViews() {
        backgroundColor = .vkWhite
    }
    
    func setupLayout() {
        addSubview(logoImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoWidthConstraint,
            logoHeightConstraint,
        ])
    }
}

//MARK: - Animations
private extension CustomLaunchscreenView {
    func logoAppearanceAnimation(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 3.0) {
            self.logoImageView.alpha = 1
        } completion: { _ in
            completion()
        }
    }
    
    func logoGainAnimation(completion: @escaping () -> Void) {
        self.layoutIfNeeded()
        NSLayoutConstraint.deactivate([
            self.logoWidthConstraint,
            self.logoHeightConstraint,
        ])
        self.logoWidthConstraint = self.logoImageView.widthAnchor.constraint(equalToConstant: 150)
        self.logoHeightConstraint = self.logoImageView.heightAnchor.constraint(equalToConstant: 150)
        
        UIView.animate(withDuration: 0.7,
                       delay: 0.0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut,
                       animations: {
            NSLayoutConstraint.activate([
                self.logoWidthConstraint,
                self.logoHeightConstraint,
            ])
            self.layoutIfNeeded()
        },
                       completion: { _ in
            completion()
        })
    }
    
    func logoHideAnimation(completion: @escaping () -> Void) {
        self.layoutIfNeeded()
        NSLayoutConstraint.deactivate([
            self.logoWidthConstraint,
            self.logoHeightConstraint,
        ])
        self.logoWidthConstraint = self.logoImageView.widthAnchor.constraint(equalToConstant: 1)
        self.logoHeightConstraint = self.logoImageView.heightAnchor.constraint(equalToConstant: 1)
        
        UIView.animate(withDuration: 0.15,
                       delay: 0.0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.9,
                       options: .curveEaseOut,
                       animations: {
            NSLayoutConstraint.activate([
                self.logoWidthConstraint,
                self.logoHeightConstraint,
            ])
            self.layoutIfNeeded()
        },
                       completion: { _ in
            self.logoImageView.removeFromSuperview()
            completion()
        })
    }
}

//MARK: - CustomLaunchscreenViewProtocol
extension CustomLaunchscreenView: CustomLaunchscreenViewProtocol {
    func animateLogoView() {
        logoAppearanceAnimation {
            self.logoGainAnimation {
                self.logoHideAnimation {
                    self.presenter?.logoAnimationEnded()
                }
            }
        }
    }
}
