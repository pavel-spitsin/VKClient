//
//  VKService.swift
//  VKClient
//
//  Created by Павел on 14.04.2024.
//

import Foundation
import UIKit

class VKService {
    func signIn(login: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let requestURL = URL(string: "https://oauth.vk.com/token?grant_type=password&client_id=\(VKClientID.clientID)&client_secret=\(VKClientID.clientSecret)&username=\(login)&password=\(password)&v=5.131")!
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(false, error?.localizedDescription)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let accessToken = json["access_token"] as? String,
                       let userID = json["user_id"] as? Int64 {
                        VKTokenHolder.shared.token = accessToken
                        VKTokenHolder.shared.userID = userID
                        completion(true, nil)
                    }
                    
                    if let errorDescription = json["error_description"] as? String {
                        completion(false, errorDescription)
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
                completion(false, error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func getNews(completion: @escaping ([Post]) -> Void, errorCompletion: @escaping (String) -> Void) {
        let accessToken = VKTokenHolder.shared.token!
        let ownerId = VKTokenHolder.shared.userID!

        let count = 30
        let urlString = "https://api.vk.com/method/newsfeed.get?owner_id=\(ownerId)&count=\(count)&access_token=\(accessToken)&v=5.131"

        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Ошибка при выполнении запроса: \(error.localizedDescription)")
                    errorCompletion(error.localizedDescription)
                    return
                }

                guard let data = data else {
                    print("Данные не получены")
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let news = json["response"] as? [String: Any],
                           let items = news["items"] as? [[String: Any]] {
                            var posts = [Post]()
                            
                            for item in items {
                                if let ownerID = item["owner_id"] as? Int64 {
                                    let post = Post()
                                    posts.insert(post, at: 0)
                                    post.ownerID = ownerID
                                    
                                    if let postID = item["post_id"] as? Int64 {
                                        post.postID = postID
                                    }
                                    
                                    if let text = item["text"] as? String {
                                        post.text = text
                                    }
                                    
                                    if let date = item["date"] as? Int64 {
                                        post.date = date
                                    }
                                    
                                    if let likesInfo = item["likes"] as? [String: Any],
                                       let likesCount = likesInfo["count"] as? Int64 {
                                        post.likes = likesCount
                                    }
                                    
                                    if let likesInfo = item["likes"] as? [String: Any],
                                       let like = likesInfo["user_likes"] as? Int64 {
                                        if like == 1 {
                                            post.isLiked = true
                                        } else if like == 0 {
                                            post.isLiked = false
                                        }
                                    }
                                    
                                    self.loadOwnerInfo(ownerId: ownerID) { name, imageURL in
                                        post.authorName = name
                                        self.loadAvatar(imageURL) { image in
                                            post.image = image
                                        }
                                    }
                                }
                            }
                            completion(posts)
                        }
                    }
                } catch {
                    print("Ошибка при парсинге JSON: \(error.localizedDescription)")
                }
            }
            task.resume()
        } else {
            print("Неверный URL")
        }
    }

    func loadOwnerInfo(ownerId: Int64, completion: @escaping (String, String) -> Void) {
        let accessToken = VKTokenHolder.shared.token!
        let isGroup = ownerId < 0
        let authorId = isGroup ? abs(ownerId) : ownerId
        let ownerUrlString = isGroup ?
        "https://api.vk.com/method/groups.getById?group_ids=\(authorId)&access_token=\(accessToken)&v=5.131" :
        "https://api.vk.com/method/users.get?user_ids=\(authorId)&access_token=\(accessToken)&v=5.131"
        let url = URL(string: ownerUrlString)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let response = json?["response"] as? [[String: Any]], let owner = response.first {
                    guard let imageURL = owner["photo_200"] as? String else { return }
                    
                    if let firstName = owner["first_name"] as? String,
                       let lastName = owner["last_name"] as? String {
                        completion("\(firstName) \(lastName)", imageURL)
                    }
                    
                    if let groupName = owner["name"] as? String {
                        completion("\(groupName)", imageURL)
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func loadAvatar(_ urlString: String, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else { return }
            if let image = UIImage(data: data) {
                completion(image)
            }
        }
        task.resume()
    }
    
    func likeUnlikePost(ownerId: Int64, postId: Int64, isLiked: Bool) {
        let accessToken = VKTokenHolder.shared.token!
        
        var likeAction = ""
        if isLiked {
            likeAction = "delete"
        } else {
            likeAction = "add"
        }

        let urlString = "https://api.vk.com/method/likes.\(likeAction)?type=post&owner_id=\(ownerId)&item_id=\(postId)&access_token=\(accessToken)&v=5.131"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        }
        
        task.resume()
    }
}
