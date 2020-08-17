//
//  MyClient.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 02/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation

class DotConnectionClient: APIClient {
    
    var session: URLSession
    var headers = HeaderValues()
    var httpBodyParameters = HeaderValues()
    var httpBody: Data?
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
     func getHttpBody() -> Data? {

        guard let contentType = headers.value(forKey: "Content-Type")else { return nil }
        
        if contentType.contains("application/json") {
            return try? JSONSerialization.data(withJSONObject: headers.allValues(), options: [.prettyPrinted, .sortedKeys])
        } else if contentType.contains("application/x-www-form-urlencoded") {
            let bodyString = headers.allValues().map { "\($0)=\(String(describing: $1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))" }.joined(separator: "&")
            return bodyString.data(using: .utf8)
        } else {
            return httpBody
        }
    }
    func createBoundary() -> String? {
           // Uncomment the following lines to create a boundary
           // string using a UUID value. Do not forget to comment out
           // the second way!
           /*
           var uuid = UUID().uuidString
           uuid = uuid.replacingOccurrences(of: "-", with: "")
           uuid = uuid.map { $0.lowercased() }.joined()
           
           let boundary = String(repeating: "-", count: 20) + uuid + "\(Int(Date.timeIntervalSinceReferenceDate))"
           
           return boundary
           */
           
           
           // This is the second way to create a random string to use
           // with the boundary string. Comment out the following lines
           // if you want to use the first approach above!
           let lowerCaseLettersInASCII = UInt8(ascii: "a")...UInt8(ascii: "z")
           let upperCaseLettersInASCII = UInt8(ascii: "A")...UInt8(ascii: "Z")
           let digitsInASCII = UInt8(ascii: "0")...UInt8(ascii: "9")
           
           let sequenceOfRanges = [lowerCaseLettersInASCII, upperCaseLettersInASCII, digitsInASCII].joined()
           guard let toString = String(data: Data(sequenceOfRanges), encoding: .utf8) else { return nil }
           
           var randomString = ""
           for _ in 0..<20 { randomString += String(toString.randomElement()!) }
           
           let boundary = String(repeating: "-", count: 20) + randomString + "\(Int(Date.timeIntervalSinceReferenceDate))"
           
           return boundary
       }
     func getHttpBody(withBoundary boundary: String) -> Data {
           var body = Data()
           
           for (key, value) in httpBodyParameters.allValues() {
               let values = ["--\(boundary)\r\n",
                   "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n",
                   "\(value)\r\n"]
               
               _ = body.append(values: values)
           }
           
           return body
       }
     func add(files: [FileInfo], toBody body: inout Data, withBoundary boundary: String) -> [String]? {
        var status = true
        var failedFilenames: [String]?
        
        for file in files {
            guard let filename = file.filename, let content = file.fileContents, let mimetype = file.mimetype, let name = file.name else { continue }
            
            status = false
            var data = Data()
            
            let formattedFileInfo = ["--\(boundary)\r\n",
                "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n",
                "Content-Type: \(mimetype)\r\n\r\n"]
            
            if data.append(values: formattedFileInfo) {
                if data.append(values: [content]) {
                    if data.append(values: ["\r\n"]) {
                        status = true
                    }
                }
            }
            
            
            if status {
                body.append(data)
            } else {
                if failedFilenames == nil {
                    failedFilenames = [String]()
                }
                
                failedFilenames?.append(filename)
            }
        }
        
        return failedFilenames
    }
     func close(body: inout Data, usingBoundary boundary: String) {
        _ = body.append(values: ["\r\n--\(boundary)--\r\n"])
    }
}

// MARK: - API Request calls

extension DotConnectionClient {
    //In the signature of the function we define the Class type that is the generic one in the API
    func userLogin(from endpoint: Endpoint, completion: @escaping (Result<AnyObject?, APIError>) -> Void){
        let request = endpoint.request
        callAPI(with: request, modelParser: networkModel.self, completion: completion)
    }
    func uploadData(from endpoint: Endpoint, completion: @escaping (Result<AnyObject?, APIError>) -> Void){
        let request = endpoint.request
        callAPI(with: request, modelParser: String.self, completion: completion)
    }
    func getCountryList(from endpoint: Endpoint, completion: @escaping (Result<AnyObject?, APIError>) -> Void){
           let request = endpoint.request
                  callAPI(with: request, modelParser: String.self, completion: completion)
       }
    func registerUser(from endpoint: Endpoint, completion: @escaping (Result<AnyObject?, APIError>) -> Void) {
        
        let request = endpoint.request
        callAPI(with: request, modelParser: String.self, completion: completion)
//        callAPI(with: request, decode: { json -> String? in
//
//            guard let model2 = json as? String else { return  nil }
//            return model2
//        }, completion: completion)
    }
}

