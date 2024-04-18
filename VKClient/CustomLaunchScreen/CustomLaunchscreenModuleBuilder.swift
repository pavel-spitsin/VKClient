//
//  CustomLaunchscreenModuleBuilder.swift
//  VKClient
//
//  Created by Павел on 15.04.2024
//

import UIKit

class CustomLaunchscreenModuleBuilder {
    static func build() -> CustomLaunchscreenViewController {
        let interactor = CustomLaunchscreenInteractor()
        let router = CustomLaunchscreenRouter()
        let presenter = CustomLaunchscreenPresenter(interactor: interactor, router: router)
        let viewController = CustomLaunchscreenViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
