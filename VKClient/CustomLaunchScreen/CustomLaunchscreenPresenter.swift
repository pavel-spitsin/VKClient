//
//  CustomLaunchscreenPresenter.swift
//  VKClient
//
//  Created by Павел on 15.04.2024
//

protocol CustomLaunchscreenPresenterProtocol: AnyObject {
    func viewDidAppear()
    func logoAnimationEnded()
}

class CustomLaunchscreenPresenter {
    //MARK: - Property
    weak var view: CustomLaunchscreenViewControllerProtocol?
    var router: CustomLaunchscreenRouterProtocol
    var interactor: CustomLaunchscreenInteractorProtocol

    //MARK: - Init
    init(interactor: CustomLaunchscreenInteractorProtocol, router: CustomLaunchscreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

//MARK: - CustomLaunchscreenPresenterProtocol
extension CustomLaunchscreenPresenter: CustomLaunchscreenPresenterProtocol {
    func viewDidAppear() {
        view?.startLogoAnimation()
    }
    
    func logoAnimationEnded() {
        router.openEnterScreen()
    }
}
