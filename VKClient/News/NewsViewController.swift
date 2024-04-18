//
//  NewsViewController.swift
//  VKClient
//
//  Created by Павел on 16.04.2024
//

import UIKit

protocol NewsViewProtocol: AnyObject, BaseViewControllerProtocol {
    func addPostsToLenght(posts: [Post])
}

class NewsViewController: BaseViewController {
    //MARK: - Property
    var presenter: NewsPresenterProtocol?
    var postLenght = [Post]()
    private lazy var navigationTitleView: CustomNavigationTitleView = {
        CustomNavigationTitleView(image: nil, title: "Новости")
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(NewsListCell.self, forCellReuseIdentifier: "NewsListCell")
        return tableView
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear()
    }
}

//MARK: - Private functions
private extension NewsViewController {
    func initialize() {
        view.backgroundColor = .vkGray400
        setupNavigationBar()
        setupLayout()
    }
    
    func setupNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .vkWhite
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.hidesBackButton = true
        navigationItem.titleView = navigationTitleView
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

//MARK: - NewsViewProtocol
extension NewsViewController: NewsViewProtocol {
    func addPostsToLenght(posts: [Post]) {
        DispatchQueue.main.async {
            self.postLenght.insert(contentsOf: posts, at: 0)
            self.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postLenght.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListCell.identifier,
                                                       for: indexPath) as? NewsListCell else {
            return UITableViewCell()
        }
        cell.delegate = presenter as? any NewsListCellDelegate
        cell.post = postLenght[indexPath.row]
        return cell
    }
}
