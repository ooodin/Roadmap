//
//  JSONDataFetcher.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation

struct JSONDataFetcher {
    enum Method: String {
        case get = "GET"
        case patch = "PATCH"
    }
    
    enum Error: Swift.Error {
        case invalidURL
    }
    
    private static var urlSession: URLSession = {
        URLSession(configuration: .ephemeral)
    }()
    
    static func resume<T: Decodable>(request: URLRequest) async throws -> T {
        let data = try await urlSession.data(for: request).0
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    static func resume<T: Decodable>(url: URL, method: Method) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return try await resume(request: request)
    }

    static func get<T: Decodable>(url: URL) async throws -> T {
        try await resume(url: url, method: .get)
    }
    
    static func patch<T: Decodable>(url: URL) async throws -> T {
        try await resume(url: url, method: .patch)
    }
}
