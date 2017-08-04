//
//  UserViewCell.swift
//  GithubKitForSample
//
//  Created by marty-suzuki on 2017/08/05.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit

public final class UserViewCell: UITableViewCell, Nibable {
    private static let shared = UserViewCell.makeFromNib()

    public static func calculateHeight(with user: User, and tableView: UITableView) -> CGFloat {
        return 0
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with user: User) {
        
    }
}
