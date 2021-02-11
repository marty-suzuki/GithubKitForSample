//
//  UserViewCell.swift
//  GithubKitForSample
//
//  Created by marty-suzuki on 2017/08/05.
//  Copyright © 2021年 marty-suzuki. All rights reserved.
//

import Combine
import UIKit

public typealias UserViewCell = TableViewCell<UserView>

extension UserViewCell {
    private static let shared = UserViewCell(style: .default, reuseIdentifier: nil)
    private static let minimumHeight: CGFloat = 88

    public static func calculateHeight(with user: User, and tableView: UITableView) -> CGFloat {
        shared.configure(with: user)
        shared.frame.size.width = tableView.bounds.size.width
        shared.layoutIfNeeded()
        shared.view.bioLabel.preferredMaxLayoutWidth = shared.view.bioLabel.bounds.size.width
        let height = shared.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return max(minimumHeight, height)
    }
}

public final class UserView: UIView, ReusableView {
    fileprivate let thumbnailImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 64),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        return imageView
    }()

    fileprivate let bioLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    fileprivate let userNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .systemBlue
        return label
    }()

    fileprivate let repositoryContentView: RightSpaceContentView = {
        let view = RightSpaceContentView(frame: .zero)
        view.setImage(.repo)
        return view
    }()

    fileprivate let followingContentView: RightSpaceContentView = {
        let view = RightSpaceContentView(frame: .zero)
        view.setImage(.eye)
        return view
    }()

    fileprivate let followerContentView: RightSpaceContentView = {
        let view = RightSpaceContentView(frame: .zero)
        view.setImage(.people)
        return view
    }()

    fileprivate let locationContentView: RightSpaceContentView = {
        let view = RightSpaceContentView(frame: .zero)
        view.setImage(.location)
        return view
    }()

    fileprivate private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                userNameLabel,
                bioLabel,
                locationContentView,
                {
                    let stackView = UIStackView(
                        arrangedSubviews: [
                            repositoryContentView,
                            followingContentView,
                            followerContentView
                        ]
                    )
                    stackView.axis = .horizontal
                    stackView.distribution = .fillEqually
                    stackView.spacing = 4
                    stackView.alignment = .leading
                    return stackView
                }()
            ]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 4
        return stackView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(thumbnailImageView)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 12),
            stackView.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var imageTask: AnyCancellable?
    
    public func prepareForReuse() {
        imageTask?.cancel()
        imageTask = nil
        thumbnailImageView.image = nil
        userNameLabel.text = nil
        bioLabel.text = nil
        repositoryContentView.setText(nil)
        followingContentView.setText(nil)
        followerContentView.setText(nil)
        locationContentView.setText(nil)
    }
    
    public func configure(with user: User) {
        imageTask = loadImage(with: user.avatarURL, into: thumbnailImageView)
        userNameLabel.text = user.login
        repositoryContentView.setText(user.repositoryCount.truncateString)
        followingContentView.setText(user.followingCount.truncateString)
        followerContentView.setText(user.followerCount.truncateString)

        locationContentView.isHidden = user.location?.isEmpty ?? true
        locationContentView.setText(user.location)

        bioLabel.isHidden = user.bio?.isEmpty ?? true
        bioLabel.text = user.bio
    }
}

#if DEBUG
import SwiftUI

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView<UserView>(
            make: {
                UserView(frame: .zero)
            },
            update: { userview in
                let user = User(
                    id: "test-id",
                    avatarURL: URL(string: "https://github.com/")!,
                    followerCount: 100,
                    followingCount: 10,
                    login: "user-name",
                    repositoryCount: 200,
                    url: URL(string: "https://github.com/")!,
                    websiteURL: nil,
                    location: "NY",
                    bio: "Sample text"
                )
                userview.configure(with: user)
                userview.backgroundColor = .red
                userview.thumbnailImageView.backgroundColor = .green
                userview.stackView.backgroundColor = .yellow
            }
        )
        .frame(height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .previewDevice("iPhone 12 Pro")
    }
}
#endif
