//
//  EnterModuleBuilder.swift
//  VKClient
//
//  Created by Павел on 15.04.2024
//

import UIKit

class EnterModuleBuilder {
    static func build() -> EnterViewController {
        let interactor = EnterInteractor()
        let router = EnterRouter()
        let presenter = EnterPresenter(interactor: interactor, router: router)
        let viewController = EnterViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
