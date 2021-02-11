//
//  RepositoryViewCell.swift
//  GithubKitForSample
//
//  Created by marty-suzuki on 2017/08/05.
//  Copyright © 2021年 marty-suzuki. All rights reserved.
//

import UIKit

public typealias RepositoryViewCell = TableViewCell<RepositoryView>

extension RepositoryViewCell {
    private static let shared = RepositoryViewCell(style: .default, reuseIdentifier: nil)
    private static let minimumHeight: CGFloat = 88
    
    public static func calculateHeight(with repository: Repository, and tableView: UITableView) -> CGFloat {
        shared.configure(with: repository)
        shared.frame.size.width = tableView.bounds.size.width
        shared.layoutIfNeeded()
        shared.view.repositoryNameLabel.preferredMaxLayoutWidth = shared.view.repositoryNameLabel.bounds.size.width
        shared.view.descriptionLabel.preferredMaxLayoutWidth = shared.view.descriptionLabel.bounds.size.width
        let height = shared.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return max(minimumHeight, height)
    }
}

public final class RepositoryView: UIView, ReusableView {
    fileprivate let repositoryNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .systemBlue
        return label
    }()

    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    fileprivate let languageContentView = LanguageContentView(frame: .zero)

    fileprivate let startContentView: LeftSpaceContentView = {
        let view = LeftSpaceContentView(frame: .zero)
        view.setImage(.star)
        return view
    }()

    fileprivate let forkContentView: LeftSpaceContentView = {
        let view = LeftSpaceContentView(frame: .zero)
        view.setImage(.repoForked)
        return view
    }()

    fileprivate let updatedAtLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()

    fileprivate private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                repositoryNameLabel,
                descriptionLabel,
                {
                    let stackView = UIStackView(
                        arrangedSubviews: [
                            languageContentView,
                            startContentView,
                            forkContentView
                        ]
                    )
                    stackView.axis = .horizontal
                    stackView.alignment = .fill
                    stackView.distribution = .equalSpacing
                    return stackView
                }(),
                updatedAtLabel
            ]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(stackView)
        NSLayoutConstraint.activate([
            languageContentView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.45),
            startContentView.widthAnchor.constraint(equalTo: forkContentView.widthAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func prepareForReuse() {
        repositoryNameLabel.text = nil
        startContentView.setText(nil)
        forkContentView.setText(nil)
        updatedAtLabel.text = nil
        descriptionLabel.text = nil
    }

    public func configure(with repository: Repository) {
        repositoryNameLabel.text = repository.name

        languageContentView.isHidden = repository.language == nil
        languageContentView.setText(repository.language?.name)
        languageContentView.setColor(repository.language.flatMap { UIColor(hexString: $0.color) })

        startContentView.setText(repository.stargazerCount.truncateString)
        forkContentView.setText(repository.forkCount.truncateString)

        descriptionLabel.isHidden = repository.introduction?.isEmpty ?? true
        descriptionLabel.text = repository.introduction

        let updatedAt = DateFormatter.default.string(from: repository.updatedAt)
        updatedAtLabel.text = "Updated on \(updatedAt)"
    }
}

extension RepositoryView {
    fileprivate final class LanguageContentView: UIView {
        private let colorView: UIView = {
            let view = UIView(frame: .zero)
            view.layer.masksToBounds = true
            view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
            return view
        }()

        private let textLabel: UILabel = {
            let label = UILabel(frame: .zero)
            label.font = .boldSystemFont(ofSize: 14)
            label.textColor = .black
            return label
        }()

        override init(frame: CGRect) {
            super.init(frame: frame)

            let stackView = UIStackView(
                arrangedSubviews: [
                    colorView,
                    textLabel
                ]
            )
            stackView.axis = .horizontal
            stackView.spacing = 4
            stackView.distribution = .fill
            stackView.alignment = .fill
            stackView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(stackView)
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setColor(_ color: UIColor?) {
            colorView.backgroundColor = color
            colorView.layoutIfNeeded()
        }

        func setText(_ text: String?) {
            textLabel.text = text
        }

        override func layoutSubviews() {
            let size = colorView.bounds.size.width
            colorView.layer.cornerRadius = size / 2
            super.layoutSubviews()
        }
    }
}

#if DEBUG
import SwiftUI

struct ReposiotyView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView<RepositoryView>(
            make: {
                RepositoryView(frame: .zero)
            },
            update: { view in
                let repository = Repository(
                    name: "Repository name",
                    introduction: "Intoroduction",
                    language: Repository.Language(name: "Swift", color: "EFEFEF"),
                    stargazerCount: 100,
                    forkCount: 200,
                    url: URL(string: "https://github.com")!,
                    updatedAt: Date()
                )
                view.configure(with: repository)
                view.backgroundColor = .red
                view.stackView.backgroundColor = .yellow
            }
        )
        .frame(height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .previewDevice("iPhone 12 Pro")
    }
}
#endif
