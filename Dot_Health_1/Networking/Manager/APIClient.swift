//
//  APIClient.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 02/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation

// Code for generic API calling and decoding of response

protocol APIClient {
    var session: URLSession { get }
    func callAPI<T: Decodable> (with request: URLRequest,modelParser : T.Type,
    completion: @escaping (Result<AnyObject?, APIError>) -> Void)
}

extension APIClient {
    typealias jsonTaskCompletionHandler = (AnyObject?, APIError?) -> Void
    
    private func decodingTask<T: Decodable> (with request: URLRequest, decodingType: T.Type, completion: @escaping jsonTaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let _ = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            if let data = data {
                do {
                    if decodingType == String.self{
                        let genericModel = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                        completion(genericModel , nil)
                    }
                    else{
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .useDefaultKeys
                        let genericModel = try decoder.decode(decodingType, from: data)
                        completion(genericModel as AnyObject,nil)
                    }
                } catch {
                    completion(nil, .jsonConversionFailure)
                }
            } else {
                completion(nil, .invalidData)
            }
       
//                completion(nil, .responseUnsuccessful)
            
        }
        return task
    }
    
    func callAPI<T: Decodable> (with request: URLRequest,modelParser : T.Type,
                              completion: @escaping (Result<AnyObject?, APIError>) -> Void) {
        let task = decodingTask(with: request, decodingType: T.self) { (json, error) in
            
            // Switch to main queue
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData))
                    }
                    return
                }
                
//                if let value = decode(json) {
                    completion(Result.success(json))
//                } else {
//                    completion(Results.failure(.jsonParsingFailure))
//                }
            }
        }
        task.resume()
    }
}
// MARK: - Data Extension
extension Data {
    mutating func append<T>(values: [T]) -> Bool {
        var newData = Data()
        var status = true
        
        if T.self == String.self {
            for value in values {
                guard let convertedString = (value as! String).data(using: .utf8) else { status = false; break }
                newData.append(convertedString)
            }
        } else if T.self == Data.self {
            for value in values {
                newData.append(value as! Data)
            }
        } else {
            status = false
        }
        
        
        if status {
            self.append(newData)
        }
        
        return status
    }
}
