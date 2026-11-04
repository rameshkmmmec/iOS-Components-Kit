//
//  NetworkManager.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 04/11/26.
//

import Foundation
import Combine

final class NetworkManager: NetworkManagerProtocol {

    static let shared = NetworkManager()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // 1. Request with async logic
    func asyncRequest<T>(endPoint: any EndPoint) async throws -> T where T : Decodable {

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
        
        // to print json request
        request.logRequest()
        
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
            
            // to print response
            data.logJSON(for: T.self)
            
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
            
        } catch let DecodingError.keyNotFound(key, context) {
            let missingPath = context.codingPath.map { $0.stringValue }.joined(separator: " -> ")
            print("""
            ❌ [DECODING ERROR - MISSING KEY]
               Missing Key Name: "\(key.stringValue)"
               Location / Path : Root -> \(missingPath.isEmpty ? "Root" : missingPath)
               Debug Description: \(context.debugDescription)
            """)
            throw NetworkError.decodingError(DecodingError.keyNotFound(key, context))
            
        } catch let DecodingError.valueNotFound(type, context) {
            let missingPath = context.codingPath.map { $0.stringValue }.joined(separator: " -> ")
            print("""
            ❌ [DECODING ERROR - NULL VALUE FOUND]
               Expected Type: "\(type)" but got null
               Missing Property: "\(context.codingPath.last?.stringValue ?? "Unknown")"
               Path            : Root -> \(missingPath)
               Debug Description: \(context.debugDescription)
            """)
            throw NetworkError.decodingError(DecodingError.valueNotFound(type, context))
            
        } catch let DecodingError.typeMismatch(type, context) {
            let mismatchPath = context.codingPath.map { $0.stringValue }.joined(separator: " -> ")
            print("""
            ❌ [DECODING ERROR - TYPE MISMATCH]
               Expected Type: "\(type)"
               Wrong Property: "\(context.codingPath.last?.stringValue ?? "Unknown")"
               Path          : Root -> \(mismatchPath)
               Debug Description: \(context.debugDescription)
            """)
            throw NetworkError.decodingError(DecodingError.typeMismatch(type, context))
            
        } catch {
            print("❌ Other Network/Decoding Error: \(error)")
            throw NetworkError.decodingError(error)
        }
    }
 
    // 2. Request with Combine LOGIC
    func requestPublisher<T>(endpoint: any EndPoint) -> AnyPublisher<T, NetworkError> where T : Decodable {
        
        guard var components = URLComponents(string: endpoint.baseURL + endpoint.path) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 1. Custom headers (agar endpoint me define hain)
        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // 2. set HTTP Body for (POST / PUT / PATCH)
        if let body = endpoint.body {
            do {
                let wrappedBody = AnyEncodable(body)
                request.httpBody = try JSONEncoder().encode(wrappedBody)
            } catch {
                return Fail(error: NetworkError.encodingError(error)).eraseToAnyPublisher()
            }
        }
        
        
        // 3. Request print karein (Headers, Body, URL sab log hoga)
        request.logRequest(tag: "OUTGOING REQUEST")
        
        let decoder = JSONDecoder()
        //decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return session.dataTaskPublisher(for: request)
            .mapError { NetworkError.unknow(($0)) }
            .flatMap { output -> AnyPublisher<Data, NetworkError> in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    return Fail(error: NetworkError.serverError(statusCode: httpResponse.statusCode)).eraseToAnyPublisher()
                }
                // to print output json data
                output.data.logJSON(for: T.self)
                
                return Just(output.data)
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error -> NetworkError in
                
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .keyNotFound(let key, let context):
                        print("❌ MISSING KEY: \(key.stringValue) at path: \(context.codingPath.map { $0.stringValue })")
                    case .valueNotFound(let type, let context):
                        print("❌ NULL VALUE for property: \(context.codingPath.last?.stringValue ?? "") (expected \(type))")
                    case .typeMismatch(let type, let context):
                        print("❌ TYPE MISMATCH for property: \(context.codingPath.last?.stringValue ?? "") (expected \(type))")
                    default:
                        print("❌ Decoding failed: \(decodingError)")
                    }
                    return NetworkError.decodingError(decodingError)
                }
                return (error as? NetworkError) ?? NetworkError.decodingError(error)
            }
            .eraseToAnyPublisher()
    }
    
    
}
