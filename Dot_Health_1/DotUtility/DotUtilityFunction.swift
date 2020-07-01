//
//  DotUtilityFunction.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 17/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation
import UIKit

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
    
    //Will return lable with status and status color
    static func setStatusColor(status: String, label: UILabel)->UILabel{
        switch status {
        case "Attended":
            label.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            
        case "Scheduled":
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
