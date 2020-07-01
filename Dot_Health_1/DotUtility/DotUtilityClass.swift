//
//  DotUtilityClass.swift
//  lottie
//
//  Created by Animesh Mohanty on 02/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
extension NSAttributedString{
    func createAttributedString(first:String,second:String,fColor:UIColor,sColor:UIColor,fBold:Bool,sBold:Bool)->NSMutableAttributedString{
        
        var fFont = UIFont()
        var sFont = UIFont()
        if fBold{
             fFont = UIFont.boldSystemFont(ofSize: 13)
        }
        else{
             fFont = UIFont.systemFont(ofSize: 13)
        }
        if sBold{
             sFont = UIFont.boldSystemFont(ofSize: 13)
        }
        else{
             sFont = UIFont.systemFont(ofSize: 13)
        }
        let attributedTitle = NSMutableAttributedString(string: first, attributes: [NSAttributedString.Key.font: fFont, NSAttributedString.Key.foregroundColor: fColor])
        
        attributedTitle.append(NSAttributedString(string: second, attributes: [NSAttributedString.Key.font: sFont, NSAttributedString.Key.foregroundColor: sColor]))
        
        return attributedTitle
    }
}
