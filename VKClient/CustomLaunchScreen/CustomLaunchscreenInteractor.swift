//
//  CustomLaunchscreenInteractor.swift
//  VKClient
//
//  Created by Павел on 15.04.2024
//

protocol CustomLaunchscreenInteractorProtocol: AnyObject {
}

class CustomLaunchscreenInteractor: CustomLaunchscreenInteractorProtocol {
    //MARK: - Property
    weak var presenter: CustomLaunchscreenPresenterProtocol?
}
