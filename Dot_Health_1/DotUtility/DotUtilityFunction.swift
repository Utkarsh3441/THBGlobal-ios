//
//  DotUtilityFunction.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 17/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation
import UIKit
import Security

class UtilityFunctions{
    
    static func getDateAsString(inputDate:Date)->String{
        let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: inputDate) as? String ?? "Date"
    }
    
    
    static func getTimeAsString(inputTime:Date)->String{
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter.string(from: inputTime) as? String ?? "Time"
    }
    static func getTodayDate()->String{
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .medium
        return dateFormater.string(from: Date())
    }
    static func getTodayDateFormat()->String{
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .medium
        dateFormater.dateFormat = "yyyy-MM-dd"
        return dateFormater.string(from: Date())
    }
    static func getTFormattedDate(date:Date)->String{
          let dateFormater = DateFormatter()
          dateFormater.dateStyle = .medium
          dateFormater.dateFormat = "yyyy-MM-dd"
          return dateFormater.string(from: date)
      }

    
    //Will return lable with status and status color
    static func setStatusColor(status: String, label: UILabel)->UILabel{
        switch status {
        case "Attended":
            label.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            
        case "scheduled":
            label.textColor = #colorLiteral(red: 1, green: 0.462533474, blue: 0, alpha: 1)
           
        case "Missed":
            label.textColor = #colorLiteral(red: 0.9034865499, green: 0, blue: 0.2168298364, alpha: 1)
            
            
        default:
            label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        label.text = status
        return label
    }
}
class KeychainService {
    class func updatePassword(service: String, account: String, data: String) {
        guard let dataFromString = data.data(using: .utf8, allowLossyConversion: false) else {
            return
        }

        let status = SecItemUpdate(modifierQuery(service: service, account: account), [kSecValueData: dataFromString] as CFDictionary)

        checkError(status)
    }

    class func removePassword(service: String, account: String) {
        let status = SecItemDelete(modifierQuery(service: service, account: account))

        checkError(status)
    }

    class func savePassword(service: String, account: String, data: String) {
        guard let dataFromString = data.data(using: .utf8, allowLossyConversion: false) else {
            return
        }

        let keychainQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                              kSecAttrService: service,
                                              kSecAttrAccount: account,
                                              kSecValueData: dataFromString]

        let status = SecItemAdd(keychainQuery as CFDictionary, nil)

        checkError(status)
    }

    class func loadPassword(service: String, account: String) -> String? {
        var dataTypeRef: CFTypeRef?

        let status = SecItemCopyMatching(modifierQuery(service: service, account: account), &dataTypeRef)

        if status == errSecSuccess,
            let retrievedData = dataTypeRef as? Data {
            return String(data: retrievedData, encoding: .utf8)
        } else {
            checkError(status)

            return nil
        }
    }

    fileprivate static func modifierQuery(service: String, account: String) -> CFDictionary {
        let keychainQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                              kSecAttrService: service,
                                              kSecAttrAccount: account,
                                              kSecReturnData: kCFBooleanTrue]

        return keychainQuery as CFDictionary
    }
    class func removeUserFromKey(service:String) {
       let secItemClasses = [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity]
        for itemClass in secItemClasses {
            let spec: NSDictionary = [kSecClass: itemClass]
            SecItemDelete(spec)
        }
    }
    fileprivate static func checkError(_ status: OSStatus) {
        if status != errSecSuccess {
            if #available(iOS 11.3, *),
            let err = SecCopyErrorMessageString(status, nil) {
                print("Operation failed: \(err)")
            } else {
                print("Operation failed: \(status). Check the error message through https://osstatus.com.")
            }
        }
    }
}
extension NSMutableAttributedString {

   public func setAsLink(textToFind:String, linkURL:String) -> Bool {

    let foundRange = self.mutableString.range(of: textToFind)
       if foundRange.location != NSNotFound {
        self.addAttribute(NSAttributedString.Key.link, value: linkURL, range: foundRange)
           return true
       }
       return false
   }
}
