//
//  NewsListCell.swift
//  VKClient
//
//  Created by Павел on 16.04.2024.
//

import UIKit

protocol NewsListCellDelegate: AnyObject{
    func likeButtonAction(ownerID: Int64, postID: Int64, isLiked: Bool)
}

class NewsListCell: UITableViewCell {
    //MARK: - Property
    static let identifier = String(describing: NewsListCell.self)
    weak var delegate: NewsListCellDelegate?
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    private let customContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .vkWhite
        view.layer.cornerRadius = 10
        return view
    }()
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .vkBlack
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .vkGray600
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()
    private lazy var postTextLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .vkBlack
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.imageView?.tintColor = .vkGray600
        button.addTarget(self, action: #selector(likeButtonAction), for: .touchUpInside)
        return button
    }()
    private lazy var likesCountLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .vkGray600
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()

    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureComponents()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
        userImageView.layer.masksToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        dateLabel.text = ""
        postTextLabel.text = ""
        likesCountLabel.text = ""
    }
}

//MARK: - Private functions
private extension NewsListCell {
    func configureComponents() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        self.selectionStyle = .none
    }

    func setupLayout() {
        addSubview(customContentView)
        customContentView.addSubview(userImageView)
        customContentView.addSubview(nameLabel)
        customContentView.addSubview(dateLabel)
        customContentView.addSubview(postTextLabel)
        customContentView.addSubview(likeButton)
        customContentView.addSubview(likesCountLabel)
        
        customContentView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        postTextLabel.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likesCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customContentView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            customContentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            customContentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            customContentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            
            userImageView.topAnchor.constraint(equalTo: customContentView.topAnchor, constant: 8),
            userImageView.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor, constant: 8),
            userImageView.heightAnchor.constraint(equalToConstant: 40),
            userImageView.widthAnchor.constraint(equalToConstant: 40),
            
            nameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: -8),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            dateLabel.bottomAnchor.constraint(equalTo: userImageView.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 16),
            
            postTextLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 8),
            postTextLabel.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor, constant: 8),
            postTextLabel.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: -8),
            
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 10),
            likeButton.leadingAnchor.constraint(equalTo: postTextLabel.leadingAnchor),
            likeButton.bottomAnchor.constraint(equalTo: customContentView.bottomAnchor, constant: -8),
            
            likesCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor),
            likesCountLabel.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: -8),
            likesCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            likesCountLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

    @objc func likeButtonAction() {
        guard let postID = post?.postID,
              let ownerID = post?.ownerID,
              let isLiked = post?.isLiked else { return }
        delegate?.likeButtonAction(ownerID: ownerID, postID: postID, isLiked: isLiked)
    }
    
    func updateViews() {
        nameLabel.text = post?.authorName
        postTextLabel.text = post?.text

        if let postDate = post?.date {
            let time = DateService().convertInt64ToTimeString(date: postDate)
            let day = DateService().convertInt64ToDayString(date: postDate)
            dateLabel.text = "Опубликовано \(day) в \(time)"
        }
        
        userImageView.image = post?.image
        
        if let likes = post?.likes {
            likesCountLabel.text = "\(likes)"
        }

        guard let isLiked = post?.isLiked else { return }
        updateLikeInfo(isLiked: isLiked)
    }
    
    func updateLikeInfo(isLiked: Bool) {
        if isLiked {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.imageView?.tintColor = .vkRed
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.imageView?.tintColor = .vkGray600
        }
    }
}
