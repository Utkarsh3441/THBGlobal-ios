//
//  String+Extention.swift
//  sample-chat-swift
//
//  Created by Injoit on 1/28/19.
//  Copyright © 2019 Quickblox. All rights reserved.
//

import Foundation
import UIKit
extension String {
    func stringByTrimingWhitespace() -> String {
        let squashed = replacingOccurrences(of: "[ ]+",
                                            with: " ",
                                            options: .regularExpression)
        return squashed.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    func stringByTrimingSpace() -> String {
        let squashed = replacingOccurrences(of: " ",
                                            with: "",
                                            options: .regularExpression)
        return squashed.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
        func generateColor() -> UIColor {
            let hash = abs(self.hashValue)
            let colorNum = hash % (256*256*256)                     
            let redColor = colorNum >> 16
            let greenColor = (colorNum & 0x00FF00) >> 8
            let blueColor = (colorNum & 0x0000FF)
            let color = UIColor(red: CGFloat(redColor)/255.0,
                                green: CGFloat(greenColor)/255.0,
                                blue: CGFloat(blueColor)/255.0,
                                alpha: 1.0)
            return color
        }
    func toHexEncodedString(uppercase: Bool = true, prefix: String = "", separator: String = "") -> String {
        return unicodeScalars.map { prefix + .init($0.value, radix: 16, uppercase: uppercase) } .joined(separator: separator)
    }
    func stringToDate()-> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.date(from: self)
    }
    
    func base64Decoded() -> String? {
         var st = self;
         if (self.count % 4 <= 2){
             st += String(repeating: "=", count: (self.count % 4))
         }
         guard let data = Data(base64Encoded: st) else { return nil }
         return String(data: data, encoding: .utf8)
     }
//    func base64ToImage() -> UIImage? {
//
//
//
//
//
//        if let decodedData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
//            let image = UIImage(data: decodedData)
//        }
//
//        if let url = URL(string: self),let data = try? Data(contentsOf: url),let image = UIImage(data: data) {
//            return image
//        }
//        return nil
//    }
    
    func base64ToImage() -> UIImage? {
        if let url = URL(string: self),let data = try? Data(contentsOf: url),let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    
    func base64ToUrl() -> URL? {
           if let url = URL(string: self) {
               return url
           }
           return nil
       }
    
    func matches(for regex: String) -> [String] {
         do {
             let regex = try NSRegularExpression(pattern: regex)
             let results = regex.matches(in: self, range:  NSRange(self.startIndex..., in: self))
             return results.map {
                 //self.substring(with: Range($0.range, in: self)!)
                 String(self[Range($0.range, in: self)!])
             }
         } catch let error {
             print("invalid regex: \(error.localizedDescription)")
             return []
         }
     }
    
}
