//
//  UserViewController.swift
//  GithubKitForSample
//
//  Created by marty-suzuki on 2017/08/04.
//  Copyright © 2021年 marty-suzuki. All rights reserved.
//

import Combine
import GithubKit
import UIKit

final class UserViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    fileprivate private(set) var users: [User] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UserViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        
        let request = SearchUserRequest(query: "marty", after: nil, limit: 50)
        ApiSession.shared.send(request) { [weak self] in
            switch $0 {
            case .success(let value):
                self?.users = value.nodes
            case .failure(let error):
                print(error)
            }
        }.store(in: &cancellables)
    }
}

extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UserViewCell.self, for: indexPath)
        cell.configure(with: users[indexPath.row])
        return cell
    }
}

extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = RepositoryViewController(user: users[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UserViewCell.calculateHeight(with: users[indexPath.row], and: tableView)
    }
}
