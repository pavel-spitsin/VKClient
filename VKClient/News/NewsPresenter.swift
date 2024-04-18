//
//  NewsPresenter.swift
//  VKClient
//
//  Created by Павел on 16.04.2024
//

protocol NewsPresenterProtocol: AnyObject {
    func viewDidAppear()
    func postsFetched(_ post: [Post])
    func errorCaught(message: String)
}

class NewsPresenter {
    //MARK: - Properties
    weak var view: NewsViewProtocol?
    var router: NewsRouterProtocol
    var interactor: NewsInteractorProtocol

    //MARK: - Init
    init(interactor: NewsInteractorProtocol, router: NewsRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

//MARK: - NewsPresenterProtocol
extension NewsPresenter: NewsPresenterProtocol {
    func viewDidAppear() {
        interactor.loadNews()
    }
    
    func postsFetched(_ posts: [Post]) {
        view?.addPostsToLenght(posts: posts)
    }
    
    func errorCaught(message: String) {
        view?.showAlert(message: message)
    }
}

//MARK: - NewsListCellDelegate
extension NewsPresenter: NewsListCellDelegate {
    func likeButtonAction(ownerID: Int64, postID: Int64, isLiked: Bool) {
        interactor.setOrRemoveLike(ownerID: ownerID, postID: postID, isLiked: isLiked)
    }
}
