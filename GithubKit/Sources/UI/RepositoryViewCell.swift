//
//  RepositoryViewCell.swift
//  GithubKitForSample
//
//  Created by marty-suzuki on 2017/08/05.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit

public final class RepositoryViewCell: UITableViewCell, Nibable {
    private static let shared = RepositoryViewCell.makeFromNib()
    
    public static func calculateHeight(with repository: Repository, and tableView: UITableView) -> CGFloat {
        return 0
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with repository: Repository) {
        
    }
}
