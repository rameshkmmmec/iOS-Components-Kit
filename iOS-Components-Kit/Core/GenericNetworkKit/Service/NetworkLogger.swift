//
//  NetworkLogger.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 04/11/26.
//

import Foundation

enum NetworkLogger {
    
    /// Raw `Data` ko formatted (pretty-printed) JSON String me print karta hai
    static func log(data: Data, tag: String = "NETWORK RESPONSE") {
        #if DEBUG
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            
            if let prettyString = String(data: prettyData, encoding: .utf8) {
                print("""
                ================ 🚀 [\(tag)] 🚀 ================
                \(prettyString)
                ================================================
                """)
            }
        } catch {
            // Agar JSON invalid hai (HTML ya plain string error aaya ho)
            let rawString = String(data: data, encoding: .utf8) ?? "Unable to decode raw data to string"
            print("⚠️ [\(tag) - RAW]:\n\(rawString)")
        }
        #endif
    }
    
    /// Kisi bhi generic `Encodable` Swift model ko JSON String me pretty-print karta hai
    static func log<T: Encodable>(model: T, tag: String = "MODEL LOG") {
        #if DEBUG
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let encodedData = try? encoder.encode(model),
           let jsonString = String(data: encodedData, encoding: .utf8) {
            print("""
            ================ 📦 [\(tag)] 📦 ================
            \(jsonString)
            ================================================
            """)
        }
        #endif
    }
}

extension Data {
    /// Generic pretty-printed JSON logger for debugging API responses
    func logJSON<T>(for type: T.Type) {
        #if DEBUG
        if let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            print("""
            ================ 🚀 [API RESPONSE: \(T.self)] 🚀 ================
            \(prettyString)
            ==================================================================
            """)
        } else if let rawString = String(data: self, encoding: .utf8) {
            print("⚠️ [RAW RESPONSE for \(T.self)]:\n\(rawString)")
        }
        #endif
    }
}


extension URLRequest {
    /// Request URL, Method, Headers aur Body ko clean format me print karta hai
    func logRequest(tag: String = "OUTGOING REQUEST") {
        #if DEBUG
        let urlString = self.url?.absoluteString ?? "Invalid URL"
        let method = self.httpMethod ?? "GET"
        let headers = self.allHTTPHeaderFields ?? [:]
        
        var bodyString = "None"
        if let httpBody = self.httpBody {
            if let jsonObject = try? JSONSerialization.jsonObject(with: httpBody, options: []),
               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let pretty = String(data: prettyData, encoding: .utf8) {
                bodyString = pretty
            } else {
                bodyString = String(data: httpBody, encoding: .utf8) ?? "Unreadable Data"
            }
        }
        
        print("""
        ================ 📤 [\(tag)] 📤 ================
        👉 URL   : \(urlString)
        👉 Method: \(method)
        👉 Headers:
        \(headers.isEmpty ? "   None" : headers.map { "   \($0.key): \($0.value)" }.joined(separator: "\n"))
        👉 Body:
        \(bodyString)
        ====================================================
        """)
        #endif
    }
}
