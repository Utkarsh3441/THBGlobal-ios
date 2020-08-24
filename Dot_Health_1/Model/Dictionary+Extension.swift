//
//  Dictionary+Extension.swift
//  Dot_Health_1
//
//  Created by Utkarsh Agarwal on 8/25/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func returnStringForKey(key:String)->String
    {
        
        if  let val = self[key as! Key] as? String {
            return val
        }
        if  let val = self[key as! Key] as? Int {
            return "\(val)"
        }
        if  let val = self[key as! Key] as? NSNumber {
            return "\(val)"
        }
        return ""
    }
    
    func returnIntForKey(key:String) -> Int {
        if  let val = self[key as! Key] as? Int {
            return val
        }
        if  let val = self[key as! Key] as? Float {
            return Int(val)
        }
        if  let val = self[key as! Key] as? Double {
            return Int(val)
        }
//        else if let val = self[key as! Key] as? String {
//            return val.intValue()
//        }
        return 0
    }
    
    func returnFloatForKey(key:String) -> Float {
        if  let val = self[key as! Key] as? Float {
            return val
        }
        if  let val = self[key as! Key] as? Double {
            return Float(val)
        }
        if  let val = self[key as! Key] as? Int {
            return Float(val)
        }
        return 0.0
    }
    
    
    func returnDoubleForKey(key:String) -> Double {
        if  let val = self[key as! Key] as? Double {
            return val
        }
        if  let val = self[key as! Key] as? Float {
            return Double(val)
        }
        if  let val = self[key as! Key] as? Int {
            return Double(val)
        }
//        else if let val = self[key as! Key] as? String {
//            return val.doubleValue()
//        }
        return 0.0
    }
    
    
}
