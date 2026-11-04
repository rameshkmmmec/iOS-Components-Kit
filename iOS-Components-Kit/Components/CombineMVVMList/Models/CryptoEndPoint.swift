//
//  CryptoEndPoint.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 04/11/26.
//

import Foundation

enum CryptoEndPoint: EndPoint {
    
    case cryptoMarkets(page: Int, perPage: Int)
    
    var baseURL: String {
        return "https://api.coingecko.com/"
    }
    
    var path: String {
        return "/api/v3/coins/markets"
    }
    
    var method: String {
        return "GET"
    }
    
    var queryItems: [URLQueryItem]? {
        
        switch self {
        case .cryptoMarkets(let page, let perPage):
            return [
                URLQueryItem(name: "vs_currency", value: "usd"),
                URLQueryItem(name: "order", value: "market_cap_desc"),
                URLQueryItem(name: "per_page", value: "\(perPage)"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        default:
            return nil
        }
    }
        
    
}
