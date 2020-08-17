//
//  Endpoint.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 02/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String:String]

enum HTTPMethod: String {
    case get        = "GET"
    case post       = "POST"
    case put        = "PUT"
    case delete     = "DELETE"
    case patch      = "PATCH"
    case head       = "HEAD"
    case trace      = "TRACE"
    case connect    = "CONNECT"
    case options    = "OPTIONS"
}

public struct Endpoint {
    var path: String
    var httpMethod: HTTPMethod
    var headers: HTTPHeaders?
    var body: Data?
    var queryItems: [URLQueryItem]?
}

// MARK: - Request Setup

extension Endpoint {
    
    var urlComponents: URLComponents {
        let base: String = "your/base/string"
        var component = URLComponents(string: base)!
        component.path = path
        component.queryItems = queryItems
        return component
    }
    
    var request: URLRequest {
        var request = URLRequest(url: URL(string: urlComponents.description.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "%3A", with: ":"))!)
        request.httpMethod  = httpMethod.rawValue
        request.httpBody    = body
        if  let headers = headers {
            for(headerField, headerValue) in headers {
                request.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        request.httpShouldHandleCookies = true
        return request
    }
}
