//
//  NetworkProtocol.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 04/11/26.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    func asyncRequest<T: Decodable>(endPoint: EndPoint) async throws -> T
    func requestPublisher<T: Decodable>(endpoint: EndPoint) -> AnyPublisher<T, NetworkError>
}
