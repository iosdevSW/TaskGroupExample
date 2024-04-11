//
//  NetworkService.swift
//  TaskGroupExample
//
//  Created by iOS신상우 on 4/9/24.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case networkError
}

class NetworkService {
    static let shared = NetworkService()
    
    private init() { }
    
    private let baseUrl = "https://koreanjson.com"
    
    func getTodos(id: Int) async throws -> String {
        guard let url = URL(string: baseUrl + "/todos" + "/\(id)") else {
            throw NetworkError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw NetworkError.networkError
        }
        
        let resultString = String(data: data, encoding: .utf8)
        
        return resultString ?? "-"
    }
    
    func getPosts(id: Int) async throws -> String {
        guard let url = URL(string: baseUrl + "/posts" + "/\(id)") else {
            throw NetworkError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw NetworkError.networkError
        }
        
        let resultString = String(data: data, encoding: .utf8)
        
        return resultString ?? "-"
    }
}
