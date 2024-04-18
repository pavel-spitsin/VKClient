//
//  EnterInteractor.swift
//  VKClient
//
//  Created by Павел on 15.04.2024
//

protocol EnterInteractorProtocol: AnyObject {
}

class EnterInteractor: EnterInteractorProtocol {
    //MARK: - Property
    weak var presenter: EnterPresenterProtocol?
}
