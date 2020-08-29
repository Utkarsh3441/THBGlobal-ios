//
//  EndpointList.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 02/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation

enum API: String {
     case api1 = "http://104.215.179.29/v1/"
     case patientsApi = "http://104.215.179.29/v1/patients/"
     case api2 = "http://104.215.179.29/v1/sessions"
    
    
    // To get the API endpoint with request setup
    func getPostAPIEndpointForAll(urlString:String ,httpMethod : HTTPMethod ,queryItems: [URLQueryItem]? = [], headers: HTTPHeaders? = [ : ], body: Data? = Data()) -> Endpoint {
            return Endpoint(path: urlString, httpMethod: httpMethod, headers: headers, body: body, queryItems: queryItems)
    }
   func getPostAPIEndpoint(urlString:String ,queryItems: [URLQueryItem]? = [], headers: HTTPHeaders = [ : ], body: Data = Data()) -> Endpoint {
            return Endpoint(path: urlString, httpMethod: .post, headers: headers, body: body, queryItems: queryItems)
    }
    func getPostAPIEndpointForAppointments(urlString:String ,queryItems: [URLQueryItem]? = [], headers: HTTPHeaders? = [ : ], body: Data? = Data()) -> Endpoint {
            return Endpoint(path: urlString, httpMethod: .get, headers: headers, body: body, queryItems: queryItems)
    }
    func getPostAPIEndpointForMedication(urlString:String ,queryItems: [URLQueryItem]? = [], headers: HTTPHeaders? = [ : ], body: Data? = Data()) -> Endpoint {
             return Endpoint(path: urlString, httpMethod: .get, headers: headers, body: body, queryItems: queryItems)
     }
    func getPostAPIEndpointForSlots(urlString:String ,queryItems: [URLQueryItem]? = [], headers: HTTPHeaders? = [ : ], body: Data? = Data()) -> Endpoint {
               return Endpoint(path: urlString, httpMethod: .get, headers: headers, body: body, queryItems: queryItems)
       }
   
}
