//
//  UITableView.ReusableView.swift
//  GithubKitForSample
//
//  Created by marty-suzuki on 2021/02/11.
//  Copyright © 2021年 marty-suzuki. All rights reserved.
//

import UIKit

extension UITableView {
    public func registerDefaultCell() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
    }

    public func register<T: ReusableView>(_ cell: TableViewCell<T>.Type) {
        register(TableViewCell<T>.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    public func dequeueReusableDefaultCell(for indexPath: IndexPath) -> UITableViewCell {
        return dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
    }
    
    public func dequeue<T: ReusableView>(_ type: TableViewCell<T>.Type, for indexPath: IndexPath) -> TableViewCell<T> {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! TableViewCell<T>
    }
}

public final class TableViewCell<T: ReusableView>: UITableViewCell {
    let view: T = {
        let view = T(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        view.prepareForReuse()
    }

    public func configure(with configuration: T.Configuration) {
        view.configure(with: configuration)
    }
}
