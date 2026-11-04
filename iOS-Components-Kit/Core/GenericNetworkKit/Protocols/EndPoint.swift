//
//  EndPoint.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 04/11/26.
//

import Foundation


protocol EndPoint {
    
    var baseURL: String { get }
    var path: String { get }
    var method: String { get }
    var headers: [String : String]? { get }
    var body: Encodable? { get }
    var queryItems: [URLQueryItem]? { get }
}

extension EndPoint {
    
    var headers: [String : String]? { nil }
    var body: Encodable? { nil }
    var queryItem: [URLQueryItem]? { nil }
    
}
