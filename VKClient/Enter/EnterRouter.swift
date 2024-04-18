//
//  EnterRouter.swift
//  VKClient
//
//  Created by Павел on 15.04.2024
//

import Foundation
import UIKit

protocol EnterRouterProtocol {
    func openNewsScreen()
}

class EnterRouter {
    //MARK: - Property
    weak var viewController: EnterViewController?
}

//MARK: - EnterRouterProtocol
extension EnterRouter: EnterRouterProtocol {
    func openNewsScreen() {
        DispatchQueue.main.async {
            let vc = NewsModuleBuilder.build()
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
