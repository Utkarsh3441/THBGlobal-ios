//
//  UIButton+Extention.swift
//  sample-chat-swift
//
//  Created by Injoit on 9/26/19.
//  Copyright © 2019 Quickblox. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func addShadowToButton(color: UIColor = Theme.gradientColorLight!, cornerRadius: CGFloat) {
        self.backgroundColor = .white
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 12)
        self.layer.shadowColor = UIColor(red:0.22, green:0.47, blue:0.99, alpha:0.5).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 11
        self.layer.cornerRadius = cornerRadius
    }
    
    func removeShadowFromButton() {
        self.backgroundColor = .clear
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOpacity = 0
        self.layer.shadowRadius = 0
    }
}
