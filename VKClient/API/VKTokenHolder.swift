//
//  VKTokenHolder.swift
//  VKClient
//
//  Created by Павел on 15.04.2024.
//

final class VKTokenHolder {
    //MARK: - Property
    static let shared = VKTokenHolder()
    var token: String?
    var userID: Int64?

    //MARK: - Init
    private init() {}
}
