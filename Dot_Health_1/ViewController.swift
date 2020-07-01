//
//  ViewController.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 02/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
private let client = MyClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        callAPI1()
    }
    // MARK:- API Calls
      
      func callAPI1() {
          
          // Query item
          let queryItem = [ URLQueryItem(name: "keyName", value: "ValueName") ]
          
          /*
          // Body as string
          let bodyString = "yourParameterString"
          let body = bodyString.data(using: .utf8) */
          
          // Body as dictionary
          let parameters : [String : Any] = [ "key1" : "value1", "key2": "value2" ]
          guard let body = try? JSONSerialization.data(withJSONObject: parameters) else { return }
          
          // Headers
          let headers: [String: String] = [ "Header-key1": "value1",
                                            "Header-key2": "value2" ]
          
          let api: API = .api1
          let endpoint: Endpoint = api.getAPIEndpoint(queryItems: queryItem, headers: headers, body: body)
          
          client.getSomething(from: endpoint) { [weak self] result in
              switch result {
              case .success(let model2Result):
                  guard let model2Result = model2Result?.results else { return }
                  print(model2Result)
              case .failure(let error):
                  print("the error \(error)")
              }
          }
      }


}

