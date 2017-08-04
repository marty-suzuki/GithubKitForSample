//
//  Repository.swift
//  GithubApiSession
//
//  Created by marty-suzuki on 2017/08/01.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Foundation

public struct Repository: JsonDecodable {
    public let name: String
    public let introduction: String?
    public let language: String?
    public let stargazerCount: Int
    public let forkCount: Int
    public let url: URL
    
    public init(json: [AnyHashable : Any]) throws {
        guard let name = json["name"] as? String else {
            throw JsonDecodeError.parseError(object: json, key: "name", expectedType: String.self)
        }
        self.name = name
        
        if
            let languages = json["languages"] as? [AnyHashable: Any],
            let nodes = languages["nodes"] as? [[AnyHashable: Any]]
        {
            self.language = nodes.first?["name"] as? String
        } else {
            self.language = nil
        }
        
        self.stargazerCount = try TotalCountWrapper(forKey: "stargazers", json: json).value
        self.forkCount = try TotalCountWrapper(forKey: "forks", json: json).value
        self.url = try URLWrapper(forKey: "url", json: json).value
        
        self.introduction = json["description"] as? String
    }
}
