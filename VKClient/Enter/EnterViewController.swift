//
//  ViewController.swift
//  VKClient
//
//  Created by Павел on 11.04.2024.
//

import UIKit

protocol EnterViewControllerProtocol: AnyObject, BaseViewControllerProtocol {
    func startViewSetupAnimation()
}

class EnterViewController: BaseViewController {
    //MARK: - Property
    var presenter: EnterPresenterProtocol?
    private lazy var enterView: EnterView = {
        let enterView = EnterView()
        enterView.presenter = presenter
        return enterView
    }()
    private lazy var navigationTitleView: CustomNavigationTitleView = {
        CustomNavigationTitleView(image: UIImage(named: "VK_Logo"),
                                                  title: "Вход")
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationTitleView.alpha = 0
        enterView.animatedViewSetup()
        navigationTitleAppearanceAnimation()
    }
}

//MARK: - Private functions
private extension EnterViewController {
    func initialize() {
        view.backgroundColor = .vkWhite
        setupNavigationBar()
        setupLayout()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .vkWhite
        navigationItem.hidesBackButton = true
        navigationItem.titleView = navigationTitleView
    }
    
    func setupLayout() {
        view.addSubview(enterView)
        
        enterView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            enterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            enterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            enterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            enterView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

//MARK: - Animations
private extension EnterViewController {
    func navigationTitleAppearanceAnimation() {
        UIView.animate(withDuration: 0.1,
                       delay: 0.0) {
            self.navigationItem.titleView?.alpha = 1.0
        }
    }
}

//MARK: - EnterViewProtocol
extension EnterViewController: EnterViewControllerProtocol {
    func startViewSetupAnimation() {
        enterView.animatedViewSetup()
    }
}
