//
//  ViewController.swift
//  GithubKitForSample
//
//  Created by marty-suzuki on 2017/08/04.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit
import GithubKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = SearchUserRequest(query: "marty-suzuki", after: nil)
        _ = ApiSession.shared.send(request) {
            switch $0 {
            case .success(let value):
                guard let user = value.nodes.first else { return }
                let request = UserNodeRequest(id: user.id, after: nil)
                _ = ApiSession.shared.send(request) {
                    switch $0 {
                    case .success(let value):
                        print(value)
                    case .failure(let error):
                        print(error)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
