//
//  ImageLoader.swift
//  GithubKit
//
//  Created by marty-suzuki on 2021/02/11.
//  Copyright © 2021 marty-suzuki. All rights reserved.
//

import Combine
import UIKit

final class ImageLoader {
    static let shard = ImageLoader(session: .shared)

    private let session: URLSession
    private let cache = NSCache<NSURL, NSData>()

    init(session: URLSession) {
        self.session = session
    }

    func loadImage(with url: URL) -> AnyPublisher<Data, Error> {
        if let data = cache.object(forKey: url as NSURL) {
            return Just(data as Data)
                .catch { _ -> AnyPublisher<Data, Error> in }
                .eraseToAnyPublisher()
        } else {
            return session.dataTaskPublisher(for: url)
                .map { $0.data }
                .catch { error -> AnyPublisher<Data, Error> in
                    Fail(error: error).eraseToAnyPublisher()
                }
                .handleEvents(receiveOutput: { [cache] data in
                    cache.setObject(data as NSData, forKey: url as NSURL)
                })
                .eraseToAnyPublisher()
        }
    }
}

func loadImage(with url: URL, into imageView: UIImageView) -> AnyCancellable {
    ImageLoader.shard.loadImage(with: url)
        .map(UIImage.init(data:))
        .catch { _ in Just(nil) }
        .receive(on: DispatchQueue.main)
        .sink { [weak imageView] image in
            imageView?.image = image
        }
}
