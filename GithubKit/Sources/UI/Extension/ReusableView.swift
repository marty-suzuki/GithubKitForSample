//
//  ReusableView.swift
//  GithubKit
//
//  Created by marty-suzuki on 2021/02/11.
//  Copyright © 2021 marty-suzuki. All rights reserved.
//

import UIKit

public protocol ReusableView: UIView {
    associatedtype Configuration
    static var reuseIdentifier: String { get }
    func prepareForReuse()
    func configure(with configuration: Configuration)
}

extension ReusableView {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}
