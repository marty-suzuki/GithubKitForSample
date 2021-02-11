//
//  ApiSession.swift
//  GithubApiSession
//
//  Created by marty-suzuki on 2017/08/01.
//  Copyright © 2021年 marty-suzuki. All rights reserved.
//

import Combine
import Foundation

public final class ApiSession {

    public enum Error: Swift.Error {
        case emptyData
        case emptyToken
        case generateBaseURLFaild
    }

    private let session: URLSession
    private let configuration: URLSessionConfiguration
    private let injectToken: () -> InjectableToken

    public init(injectToken: @escaping () -> InjectableToken,
                configuration: URLSessionConfiguration = .default) {
        configuration.timeoutIntervalForRequest = 30
        self.configuration = configuration
        self.session = URLSession(configuration: configuration)
        self.injectToken = injectToken
    }

    public func send<T: Request>(
        _ request: T,
        completion: @escaping (Result<T.ResponseType, Swift.Error>) -> ()
    ) -> AnyCancellable {
        send(request)
            .sink(
                receiveCompletion: { result in
                    switch result {
                    case .finished:
                        return
                    case let .failure(error):
                        completion(.failure(error))
                    }
                },
                receiveValue: { value in
                    completion(.success(value))
                }
            )
    }

    public func send<T: Request>(_ request: T) -> AnyPublisher<T.ResponseType, Swift.Error> {

        let injectableToken: InjectableToken_<Ready>
        let injectableBaseURL: InjectableBaseURL
        do {
            injectableToken = try injectToken().readify()
            injectableBaseURL = try InjectableBaseURL(string: "https://api.github.com/graphql")
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }

        let proxy = RequestProxy(request: request, injectableBaseURL: injectableBaseURL, injectableToken: injectableToken)
        let urlRequest = proxy.buildURLRequest()
        return session.dataTaskPublisher(for: urlRequest)
            .flatMap { data, _ -> AnyPublisher<Data, URLError> in
                Just(data)
                    .catch { _ -> AnyPublisher<Data, URLError> in }
                    .eraseToAnyPublisher()
            }
            .catch { error -> AnyPublisher<Data, Swift.Error> in
                Fail(error: error).eraseToAnyPublisher()
            }
            .flatMap { data -> AnyPublisher<T.ResponseType, Swift.Error> in
                do {
                    return try Just(T.decode(with: data))
                        .catch { _ -> AnyPublisher<T.ResponseType, Swift.Error> in }
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
