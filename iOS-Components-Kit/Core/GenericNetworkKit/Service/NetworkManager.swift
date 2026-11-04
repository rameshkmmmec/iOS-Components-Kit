//
//  NetworkManager.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 04/11/26.
//

import Foundation


final class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T>(endPoint: any EndPoint) async throws -> T where T : Decodable {

        // 1. URL Components construction
        guard var components = URLComponents(string: endPoint.baseURL + endPoint.path) else {
            throw NetworkError.invalidURL
        }
        
        if let queryItems = endPoint.queryItems, !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        // 2. Make URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        // 3. Custom header injection
        endPoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // 4. Request body
        if let body = endPoint.body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw NetworkError.encodingError(error)
            }
        }
        
        // 5. Api Call execution
        var data: Data
        var response: URLResponse
        
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.unknow(error)
            
        }
        
        // 6.  HTTP Status code validation
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        
        // 7. Generic JSON Decoding
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
            
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
}
