//
//  NewsModuleBuilder.swift
//  VKClient
//
//  Created by Павел on 16.04.2024
//

import UIKit

class NewsModuleBuilder {
    static func build() -> NewsViewController {
        let interactor = NewsInteractor()
        let router = NewsRouter()
        let presenter = NewsPresenter(interactor: interactor, router: router)
        let viewController = NewsViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
