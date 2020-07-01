//
//  DotButtonUtility.swift
//  lottie
//
//  Created by Animesh Mohanty on 02/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class DotButtonUtility: UIButton {

    private var shadowLayer: CAShapeLayer!

       override func layoutSubviews() {
           super.layoutSubviews()
           self.backgroundColor = Theme.tintcolor
           self.layer.cornerRadius = 5
           self.clipsToBounds = true
           self.setTitleColor(.white, for: .normal)
       }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
             
        
        
    }
    
}

class OptionButton: UIButton {

    private var shadowLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.borderWidth = 1
        self.borderColor = .lightGray
        self.setTitleColor(.black, for: .normal)
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = false
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
             
      
        
    }
    
}

class ButtonUtils: UIButton {


    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
             
        self.layer.cornerRadius = 20
 
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
           
           attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.148154825, green: 0.4918324947, blue: 0.8079950213, alpha: 1)]))
           self.setAttributedTitle(attributedTitle, for: .normal)
      
//           button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
    }
   
    
}

class DotLabelUtility: UILabel {
    private var shadowLayer: CAShapeLayer!
    override func draw(_ rect: CGRect) {
        self.text = "test"
        self.textColor = #colorLiteral(red: 0.1470873058, green: 0.4721398354, blue: 0.7756891847, alpha: 1)
        self.font = UIFont.boldSystemFont(ofSize: 12)
        
        
//         if shadowLayer == nil {
//                      shadowLayer = CAShapeLayer()
//                      shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 30).cgPath
//                      shadowLayer.fillColor = UIColor.white.cgColor
//
//                      shadowLayer.shadowColor = UIColor.darkGray.cgColor
//                      shadowLayer.shadowPath = shadowLayer.path
//                      shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//                      shadowLayer.shadowOpacity = 0.8
//                      shadowLayer.shadowRadius = 2
//
//                      layer.insertSublayer(shadowLayer, at: 0)
//                      //layer.insertSublayer(shadowLayer, below: nil) // also works
//                  }
    
    }
}
class DotTextFieldUtility:UITextField{
    private var shadowLayer: CAShapeLayer!
        override func draw(_ rect: CGRect) {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2.0
            self.borderStyle = .none
            self.borderWidth = 1
            self.borderColor = #colorLiteral(red: 0.8781214356, green: 1, blue: 0.9665006995, alpha: 1)
           
            self.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.layer.cornerRadius = 8
            
            self.layer.shadowColor = #colorLiteral(red: 0.2748524845, green: 0.4150594473, blue: 0.4139105678, alpha: 1)
            self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
            self.layer.shadowOpacity = 0.5
            self.textColor = #colorLiteral(red: 0.148154825, green: 0.4918324947, blue: 0.8079950213, alpha: 1)
            self.font = UIFont(name: "KohinoorDevanagari-Regular", size: 20)
            let view = UIView()
            view.frame = CGRect(x: 0, y: 2, width: 10, height: 25)
            view.backgroundColor = UIColor.clear
            self.leftView = view
            self.leftViewMode = UITextField.ViewMode.always
         
            
            
            
        }
    }

class ActionButton: UIButton {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        backgroundColor = Theme.tintcolor
        layer.cornerRadius = frame.height / 2
        setTitleColor(UIColor.white, for: .normal)
    }
    
    class DotViewUtility: UIView{
          override func draw(_ rect: CGRect) {
        backgroundColor = #colorLiteral(red: 0.1665293276, green: 0.5254830718, blue: 0.7482460141, alpha: 1)
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.cornerRadius = 10
    }
    }

}
