//
//  CustomLaunchscreenRouter.swift
//  VKClient
//
//  Created by Павел on 15.04.2024
//

import UIKit

protocol CustomLaunchscreenRouterProtocol {
    func openEnterScreen()
}

class CustomLaunchscreenRouter {
    //MARK: - Property
    weak var viewController: CustomLaunchscreenViewController?
}

//MARK: - CustomLaunchscreenRouterProtocol
extension CustomLaunchscreenRouter: CustomLaunchscreenRouterProtocol {
    func openEnterScreen() {
        DispatchQueue.main.async {
            let vc = EnterModuleBuilder.build()
            self.viewController?.navigationController?.pushViewController(vc, animated: false)
        }
    }
}
