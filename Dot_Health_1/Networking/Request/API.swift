//
//  EndpointList.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 02/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation

enum API: String {
    case api1 = "api1/string/value"
    case api2 = "api2/string/value"
    
    // To get the API endpoint with request setup
    func getAPIEndpoint(queryItems: [URLQueryItem] = [], headers: HTTPHeaders = [ : ], body: Data = Data()) -> Endpoint {
            return Endpoint(path: self.rawValue, httpMethod: .post, headers: headers, body: body, queryItems: queryItems)
    }
}
