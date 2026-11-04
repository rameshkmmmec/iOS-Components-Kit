//
//  NetworkError.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 04/11/26.
//

import Foundation


enum NetworkError: LocalizedError {
    
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError(Error)
    case encodingError(Error)
    case unknow(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid request URL"
        case .invalidResponse: return "Unexpected response from server"
        case .serverError(let code): return "Server responded with status code: \(code)"
        case .decodingError(let error): return "Decoding failed: \(error.localizedDescription)"
        case .encodingError(let error): return "Encoding failed: \(error.localizedDescription)"
        case .unknow(let error): return error.localizedDescription
        }
    }
}
