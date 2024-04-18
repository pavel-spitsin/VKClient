//
//  NewsInteractor.swift
//  VKClient
//
//  Created by Павел on 16.04.2024
//

protocol NewsInteractorProtocol: AnyObject {
    func loadNews()
    func setOrRemoveLike(ownerID: Int64, postID: Int64, isLiked: Bool)
}

class NewsInteractor {
    //MARK: - Property
    weak var presenter: NewsPresenterProtocol?
    private let vkService = VKService()
}

//MARK: - NewsInteractorProtocol
extension NewsInteractor: NewsInteractorProtocol {
    func loadNews() {
        vkService.getNews { posts in
            self.presenter?.postsFetched(posts)
        } errorCompletion: { errorMessage in
            self.presenter?.errorCaught(message: errorMessage)
        }
    }
    
    func setOrRemoveLike(ownerID: Int64, postID: Int64, isLiked: Bool) {
        vkService.likeUnlikePost(ownerId: ownerID, postId: postID, isLiked: isLiked)
    }
}
