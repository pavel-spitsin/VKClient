//
//  CustomTitleView.swift
//  VKClient
//
//  Created by Павел on 14.04.2024.
//

import UIKit

class CustomNavigationTitleView: UIView {
    //MARK: - Property
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    //MARK: - Init
    init(image: UIImage?, title: String?) {
        super.init(frame: .zero)
        logoImageView.image = image
        titleLabel.text = title
        fillStackView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private functions
private extension CustomNavigationTitleView {
    func fillStackView() {
        if logoImageView.image != nil {
            stackView.addArrangedSubview(logoImageView)
        }
        
        if titleLabel.text != nil {
            stackView.addArrangedSubview(titleLabel)
        }
    }
    
    func setupLayout() {
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 22),

            widthAnchor.constraint(equalToConstant: 200),
            
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
