//
//  Post.swift
//  VKClient
//
//  Created by Павел on 16.04.2024.
//

import UIKit

class Post {
    var ownerID: Int64 = 0
    var postID: Int64 = 0
    var authorName: String = ""
    var date: Int64 = 0
    var text: String = ""
    var image: UIImage = UIImage()
    var likes: Int64 = 0
    var isLiked: Bool = false
}
