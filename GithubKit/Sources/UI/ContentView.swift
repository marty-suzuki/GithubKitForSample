//
//  ContentView.swift
//  GithubKit
//
//  Created by marty-suzuki on 2021/02/11.
//  Copyright © 2021 marty-suzuki. All rights reserved.
//

import UIKit

protocol ContentViewSpaceTrait {
    static func leadingConstraint(subview: UIView, superview: UIView) -> NSLayoutConstraint
    static func trailingConstraint(subview: UIView, superview: UIView) -> NSLayoutConstraint
}

enum ContentViewTraits {
    enum LeftSpace: ContentViewSpaceTrait {
        static func leadingConstraint(subview: UIView, superview: UIView) -> NSLayoutConstraint {
            subview.leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor)
        }

        static func trailingConstraint(subview: UIView, superview: UIView) -> NSLayoutConstraint {
            subview.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        }
    }
    enum RightSpace: ContentViewSpaceTrait {
        static func leadingConstraint(subview: UIView, superview: UIView) -> NSLayoutConstraint {
            subview.leadingAnchor.constraint(equalTo: superview.leadingAnchor)
        }

        static func trailingConstraint(subview: UIView, superview: UIView) -> NSLayoutConstraint {
            subview.trailingAnchor.constraint(lessThanOrEqualTo: superview.trailingAnchor)
        }
    }
}

typealias LeftSpaceContentView = ContentView<ContentViewTraits.LeftSpace>
typealias RightSpaceContentView = ContentView<ContentViewTraits.RightSpace>

final class ContentView<SpaceTrait: ContentViewSpaceTrait>: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        return imageView
    }()

    private let textLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(imageView)
        addSubview(textLabel)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4),
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            SpaceTrait.leadingConstraint(subview: imageView, superview: self),
            SpaceTrait.trailingConstraint(subview: textLabel, superview: self)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(_ image: UIImage?) {
        imageView.image = image
    }

    func setText(_ text: String?) {
        textLabel.text = text
    }
}
