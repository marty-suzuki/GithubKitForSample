//
//  Response.swift
//  GithubApiSession
//
//  Created by marty-suzuki on 2017/08/01.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Foundation

public struct Response<T: Decodable> {
    public let nodes: [T]
    public let pageInfo: PageInfo
    public let totalCount: Int
}

struct UserResponse: Decodable {
    private enum DataCodingKeys: String, CodingKey {
        case data
    }
    
    private enum SearchCodingKeys: String, CodingKey {
        case search
    }
    
    private enum CodingKeys: String, CodingKey {
        case nodes
        case pageInfo
        case totalCount = "userCount"
    }
    
    public let nodes: [User]
    public let pageInfo: PageInfo
    public let totalCount: Int
    
    public init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: DataCodingKeys.self)
        let search = try data.nestedContainer(keyedBy: SearchCodingKeys.self, forKey: .data)
        let container = try search.nestedContainer(keyedBy: CodingKeys.self, forKey: .search)
        self.nodes = try container.decode([User].self, forKey: .nodes)
        self.pageInfo = try container.decode(PageInfo.self, forKey: .pageInfo)
        self.totalCount = try container.decode(Int.self, forKey: .totalCount)
    }
}

struct RepositoryResponse: Decodable {
    private enum DataCodingKeys: String, CodingKey {
        case data
    }
    
    private enum NodeCodingKeys: String, CodingKey {
        case node
    }
    
    private enum RepositoriesCodingKeys: String, CodingKey {
        case repositories
    }
    
    private enum CodingKeys: String, CodingKey {
        case nodes
        case pageInfo
        case totalCount
    }
    
    public let nodes: [Repository]
    public let pageInfo: PageInfo
    public let totalCount: Int
    
    public init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: DataCodingKeys.self)
        let node = try data.nestedContainer(keyedBy: NodeCodingKeys.self, forKey: .data)
        let repositories = try node.nestedContainer(keyedBy: RepositoriesCodingKeys.self, forKey: .node)
        let container = try repositories.nestedContainer(keyedBy: CodingKeys.self, forKey: .repositories)
        self.nodes = try container.decode([Repository].self, forKey: .nodes)
        self.pageInfo = try container.decode(PageInfo.self, forKey: .pageInfo)
        self.totalCount = try container.decode(Int.self, forKey: .totalCount)
    }
}
