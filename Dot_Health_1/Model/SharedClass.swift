//
//  SharedClass.swift
//  Dot_Health_1
//
//  Created by Utkarsh Agarwal on 8/25/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation

class SharedClass{
    
    private static var privateObject: SharedClass? = SharedClass()
        
    private init() {}
    
  //  var selectedDataItem: DotCarePlanModel?
  

    func resetObject() {
        SharedClass.privateObject = nil
        SharedClass.privateObject = SharedClass()
    }
    
    /// to Get Singvaron Object of User
    ///
    /// - Returns: always returns single object
    class func shared() -> SharedClass {
        guard let newObj = privateObject else {
            privateObject = SharedClass()
            return privateObject!
        }
        return newObj
    }
    
    
}


