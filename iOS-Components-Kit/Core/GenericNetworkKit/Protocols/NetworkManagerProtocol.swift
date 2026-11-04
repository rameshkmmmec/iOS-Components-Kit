//
//  NetworkProtocol.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 04/11/26.
//

import Foundation

protocol NetworkManagerProtocol {
    func request<T: Decodable>(endPoint: EndPoint) async throws -> T
}
