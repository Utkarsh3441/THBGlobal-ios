//
//  DotRecords+APIExtensions.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 03/08/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation
import MobileCoreServices
import SVProgressHUD
extension DotRecordsViewController{
func loadFiles(){
   // SVProgressHUD.show()
//    DispatchQueue.global(qos: .background).async {
        print("This is run on the background queue")
    SVProgressHUD.setDefaultMaskType(.custom)
    let api : API = .api1
    let endpoint: Endpoint = api.getPostAPIEndpointForAll(urlString: "http://104.215.179.29/v1/patients/\(loginData.user_id ?? 17)/medicalReports", httpMethod: .get, queryItems: nil, headers: nil, body: nil)
        self.client.callAPI(with: endpoint.request, modelParser: RecordResponse.self) { [weak self] result in
            guard let self = self else { return }
             //   print(result)
            switch result {
            case .success(let model2Result):
                SVProgressHUD.dismiss()
                 if let model = model2Result as? RecordResponse, model.type == "Success", let recordModel = model.data {
                    print(model)
                    self.recordsDataArray = recordModel
                    self.applySnapshot(items: recordModel)
//                    let baseStr = ((model2Result as? NSArray)?.filter({($0 as? record)?.category == "Blood Report"}).first as! record).file_content!
//                    let encodingString = baseStr.data(using: .utf8)?.base64EncodedString()//Here combinedString is your string
                }
                else{
                    print("error occured")
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
//                SVProgressHUD.dismiss()
                print("the error \(error)")
            }
        }
    //}
    }
    
    func pushToPreviewController(encodedString:String) {
        let previewController = PreviewViewController()
        previewController.encodedBase64String = encodedString
        self.present(previewController, animated: true, completion: nil)
    }
    
    func loadSelectedFile(indexpath: Int){
         SVProgressHUD.show()
        //    DispatchQueue.global(qos: .background).async {
        print("This is run on the background queue")
        SVProgressHUD.setDefaultMaskType(.custom)
        let api : API = .api1
        let endpoint: Endpoint = api.getPostAPIEndpointForAll(urlString: "http://104.215.179.29/v1/patients/\(loginData.user_id ?? 17)/medicalReports/\(self.recordsDataArray[indexpath].medical_record_id ?? 0)", httpMethod: .get, queryItems: nil, headers: nil, body: nil)
        self.client.callAPI(with: endpoint.request, modelParser: RecordResponseData.self) { [weak self] result in
            guard let self = self else { return }
            //   print(result)
            switch result {
            case .success(let model2Result):
                SVProgressHUD.dismiss()
                if let model = model2Result as? RecordResponseData, model.type == "Success", let recordModel = model.data, let fileContent = recordModel.file_content {
                    if fileContent != "" {
                        self.pushToPreviewController(encodedString: fileContent)
                  }
                }
                else{
                    print("error occured")
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                //                SVProgressHUD.dismiss()
                print("the error \(error)")
            }
        }
    }

    func deleteFiles(items:record){
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.custom)
        let api : API = .api1
        let endpoint: Endpoint = api.getPostAPIEndpointForAll(urlString: "http://104.215.179.29/v1/patients/\(loginData.user_id ?? 17)/medicalReports/\(items.medical_record_id ?? 17)", httpMethod: .delete, queryItems: nil, headers: nil, body: nil)
                client.callAPI(with: endpoint.request, modelParser: String.self) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let model2Result):
                    SVProgressHUD.dismiss()
                    if let model = model2Result as? [record]{
                        self.recordsDataArray = model
                        self.applySnapshot(items: model)
    //                    let baseStr = ((model2Result as? NSArray)?.filter({($0 as? record)?.category == "Blood Report"}).first as! record).file_content!
    //                    let encodingString = baseStr.data(using: .utf8)?.base64EncodedString()//Here combinedString is your string
                    }
                    else{
                        print("error occured")
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
    //                SVProgressHUD.dismiss()
                    print("the error \(error)")
                }
            }
        }
func upload(files: [record], toURL url: URL?,
                   withHttpMethod httpMethod: HTTPMethod,
                   completion: @escaping(_ result: Result<AnyObject?, APIError>, _ failedFiles: [String]?) -> Void) {
        // SVProgressHUD.show()
           DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//               let targetURL = self?.addURLQueryParameters(toURL: url)
            guard let boundary = self?.client.createBoundary() else { return }
            let imageFileURL = URL(string: self?.dummyModel[1].cardTitle ?? "")
           
//               self?.requestHttpHeaders.add(value: "multipart/form-data; boundary=\(boundary)", forKey: "content-type")
            self?.headers.add(value: "multipart/form-data; boundary=\(boundary)", forKey: "content-type")
            let headers = ["content-type":"multipart/form-data; boundary=\(boundary)"]
//            guard var body = try? JSONSerialization.data(withJSONObject: [:]) else { completion(Result.failure(.invalidData), nil); return }
//            self?.client.httpBodyParameters.add(value: "12", forKey: "appointment_id")
//            self?.client.httpBodyParameters.add(value: files.first?.category ?? "", forKey: "category")
            self?.client.httpBodyParameters.add(value: "CT Scan", forKey: "category")

            self?.client.httpBodyParameters.add(value: "http://104.215.179.29/v1/patients/\(loginData.user_id ?? 17)/medicalReports", forKey: "storage_link")
            guard var body = self?.client.getHttpBody(withBoundary: boundary) else { return }
            
            let mimType = self?.mimeType(for: (files.first)?.category ?? "")
            guard let fileurl = URL(string:  (files.first)?.file_content ?? "") else {return}
            let _ = self?.client.add(files:  [FileInfo(withFileURL: fileurl, filename: "sampleImage.png", name: "file_content", mimetype: mimType!)], toBody: &body, withBoundary: boundary)
            self?.client.close(body: &body, usingBoundary: boundary)
                let api: API = .api1
            let endpoint: Endpoint = api.getPostAPIEndpointForAll(urlString: "http://104.215.179.29/v1/patients/\(loginData.user_id ?? 17)/medicalReports", httpMethod: httpMethod, queryItems: nil, headers: headers, body: body)
            self?.client.callAPI(with: endpoint.request, modelParser: String.self) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let model2Result):
                    SVProgressHUD.dismiss()
                   print(model2Result)
                   self.addedRecords.removeAll()
                case .failure(let error):
                    SVProgressHUD.dismiss()
                   print("the error \(error)")
                }
            }
//               guard let request = self?.prepareRequest(withURL: targetURL, httpBody: body, httpMethod: httpMethod) else { completion(Results(withError: CustomError.failedToCreateRequest), nil); return }
//
//               let sessionConfiguration = URLSessionConfiguration.default
//               let session = URLSession(configuration: sessionConfiguration)
//               let task = session.uploadTask(with: request, from: nil, completionHandler: { (data, response, error) in
//                   completion(Results(withData: data,
//                                      response: Response(fromURLResponse: response),
//                                      error: error),
//                              failedFilenames)
//               })
//               task.resume()
           }
       }

//    func uploads(files: [record], toURL url: URL,
//                       withHttpMethod httpMethod: HTTPMethod,
//                       completion: @escaping(_ result: Result<AnyObject?, APIError>, _ failedFiles: [String]?) -> Void) {
//            
//               DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//    //               let targetURL = self?.addURLQueryParameters(toURL: url)
//                guard let boundary = self?.client.createBoundary() else { return }
//                let imageFileURL = URL(string: self?.dummyModel[1].cardTitle ?? "")
//                var bod = Data()
//                self?.headers.add(value: "multipart/form-data; boundary=\(boundary)", forKey: "content-type")
//
//                (files).forEach { (record) in
//                    self?.client.httpBodyParameters.add(value: "12", forKey: "appointment_id")
//                    self?.client.httpBodyParameters.add(value: record.category ?? "", forKey: "category")
//                    self?.client.httpBodyParameters.add(value: record.storage_link ?? "", forKey: "storage_link")
//                    self?.client.httpBodyParameters.add(value: record.file_content ?? "", forKey: "file_content")
//                     guard let body = self?.client.getHttpBody(withBoundary: boundary) else { return }
//                    bod = body
//                     let _ = self?.client.add(files:  [FileInfo(withFileURL: url, filename: "sampleImage.pdf", name: "file_content", mimetype: mimType!)], toBody: &bod, withBoundary: boundary)
//                    
//                }
//               
//                // Body as dictionary
////                 guard let body = try? JSONSerialization.data(withJSONObject: paramsDictionary) else { return }
//
//                 // Headers
//                let headers = ["content-type":"multipart/form-data; boundary=\(boundary)"]
//                let mimType = self?.mimeType(for: self?.dummyModel[1].cardName ?? "")
//
//               
//                self?.client.close(body: &body, usingBoundary: boundary)
//                    let api: API = .api1
//                let endpoint: Endpoint = api.getPostAPIEndpointForAll(urlString: "http://104.215.179.29/v1/patients/17/medicalReports", httpMethod: .post, queryItems: nil, headers: headers, body: body)
//                self?.client.userLogin(from: endpoint) { [weak self] result in
//                    guard let self = self else { return }
//                    switch result {
//                    case .success(let model2Result):
//                       print(model2Result)
//            
//                    case .failure(let error):
//                 
//                        print("the error \(error)")
//                    }
//                }
//    //               guard let request = self?.prepareRequest(withURL: targetURL, httpBody: body, httpMethod: httpMethod) else { completion(Results(withError: CustomError.failedToCreateRequest), nil); return }
//    //
//    //               let sessionConfiguration = URLSessionConfiguration.default
//    //               let session = URLSession(configuration: sessionConfiguration)
//    //               let task = session.uploadTask(with: request, from: nil, completionHandler: { (data, response, error) in
//    //                   completion(Results(withData: data,
//    //                                      response: Response(fromURLResponse: response),
//    //                                      error: error),
//    //                              failedFilenames)
//    //               })
//    //               task.resume()
//               }
//           }
    private func mimeType(for path: String) -> String {
        let pathExtension = URL(fileURLWithPath: path).pathExtension as NSString

        guard
            let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, nil)?.takeRetainedValue(),
            let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue()
        else {
            return "application/octet-stream"
        }

        return mimetype as String
    }
}
