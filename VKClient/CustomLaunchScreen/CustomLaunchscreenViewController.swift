//
//  CustomLaunchscreenViewController.swift
//  VKClient
//
//  Created by Павел on 15.04.2024
//

import UIKit

protocol CustomLaunchscreenViewControllerProtocol: AnyObject {
    func startLogoAnimation()
}

class CustomLaunchscreenViewController: UIViewController {
    //MARK: - Property
    var presenter: CustomLaunchscreenPresenterProtocol?
    private lazy var launchscreenView: CustomLaunchscreenView = {
        let launchscreen = CustomLaunchscreenView()
        launchscreen.presenter = presenter
        return launchscreen
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear()
    }
}

//MARK: - Private functions
private extension CustomLaunchscreenViewController {
    func initialize() {
        view.backgroundColor = .vkWhite
        setupLayout()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    func setupLayout() {
        view.addSubview(launchscreenView)
        
        launchscreenView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            launchscreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            launchscreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            launchscreenView.topAnchor.constraint(equalTo: view.topAnchor),
            launchscreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

//MARK: - CustomLaunchscreenViewControllerProtocol
extension CustomLaunchscreenViewController: CustomLaunchscreenViewControllerProtocol {
    func startLogoAnimation() {
        launchscreenView.animateLogoView()
    }
}
