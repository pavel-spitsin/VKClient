//
//  EnterPresenter.swift
//  VKClient
//
//  Created by Павел on 15.04.2024
//

protocol EnterPresenterProtocol: AnyObject {
    func viewDidAppear()
    func signInSuccesfull()
    func errorCaught(errorMessage: String)
}

class EnterPresenter {
    //MARK: - Property
    weak var view: EnterViewControllerProtocol?
    var router: EnterRouterProtocol
    var interactor: EnterInteractorProtocol

    //MARK: - Init
    init(interactor: EnterInteractorProtocol, router: EnterRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

//MARK: - EnterPresenterProtocol
extension EnterPresenter: EnterPresenterProtocol {
    func viewDidAppear() {
        view?.startViewSetupAnimation()
    }
    
    func signInSuccesfull() {
        router.openNewsScreen()
    }
    
    func errorCaught(errorMessage: String) {
        view?.showAlert(message: errorMessage)
    }
}
