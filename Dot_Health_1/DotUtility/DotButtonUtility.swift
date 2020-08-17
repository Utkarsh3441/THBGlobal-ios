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
           self.backgroundColor = Theme.gradientColorDark
        self.borderColor = Theme.gradientColorDark
        self.borderWidth = 1
           self.layer.cornerRadius = 5
           self.clipsToBounds = true
        self.setTitleColor(Theme.tintcolor, for: .normal)
       }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
             
        
        
    }
    
}
class DotWhiteButton: UIButton {

    private var shadowLayer: CAShapeLayer!

       override func layoutSubviews() {
           super.layoutSubviews()
           self.backgroundColor = Theme.backgroundColor
        self.borderColor = Theme.gradientColorDark
        self.borderWidth = 1
           self.layer.cornerRadius = 5
           self.clipsToBounds = true
        self.setTitleColor(Theme.gradientColorDark, for: .normal)
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
 
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
           
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont(name: Theme.mainFontName, size: 16), NSAttributedString.Key.foregroundColor: Theme.gradientColorLight]))
           self.setAttributedTitle(attributedTitle, for: .normal)
      
//           button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
    }
   
    
}

class DotLabelUtility: UILabel {
    private var shadowLayer: CAShapeLayer!
    override func draw(_ rect: CGRect) {
        self.text = "test"
        self.textColor = Theme.gradientColorDark
        self.font = UIFont(name: Theme.mainFontName, size: 17)
    }
}

class FloatingLabelInput: UITextField {
    var floatingLabel: UILabel!// = UILabel(frame: CGRect.zero)
    var floatingLabelHeight: CGFloat = 14
    var button = UIButton(type: .custom)
    var imageView = UIImageView(frame: CGRect.zero)
    
    @IBInspectable
    var _placeholder: String?
    
    @IBInspectable
    var floatingLabelColor: UIColor = UIColor.black {
        didSet {
            self.floatingLabel.textColor = floatingLabelColor
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var activeBorderColor: UIColor = UIColor.blue
    
    @IBInspectable
    var floatingLabelBackground: UIColor = UIColor.white.withAlphaComponent(1) {
        didSet {
            self.floatingLabel.backgroundColor = self.floatingLabelBackground
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var floatingLabelFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            self.floatingLabel.font = self.floatingLabelFont
            self.font = self.floatingLabelFont
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var _backgroundColor: UIColor = UIColor.white {
        didSet {
            self.layer.backgroundColor = self._backgroundColor.cgColor
        }
    }
    
    
    public init(placeholder: String? = nil, cornerRadius: CGFloat, keyboardType: UIKeyboardType = .default, backgroundColor: UIColor = .clear, isSecureTextEntry: Bool = false,height :CGFloat) {
       
        super.init(frame: .zero)
        self.placeholder = placeholder
        layer.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecureTextEntry
        self.layer.backgroundColor = backgroundColor.cgColor
        floatingLabelColor = Theme.accentColor!
        self.constrainHeight(height)
        self._placeholder = placeholder
        self.floatingLabelFont = UIFont.systemFont(ofSize: 14)
        self.floatingLabel = UILabel(frame: CGRect.zero)
        self.floatingLabel.textColor = .blue
        self.floatingLabel.font = UIFont.systemFont(ofSize: 14)
        self.floatingLabel.backgroundColor = UIColor.white.withAlphaComponent(0)
        self.floatingLabel.alpha = 0
        self.font = self.floatingLabelFont
        self.addTarget(self, action: #selector(self.addFloatingLabel), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
//        self.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._placeholder = (self._placeholder != nil) ? self._placeholder : placeholder
        placeholder = self._placeholder // Make sure the placeholder is shown
        self.floatingLabel = UILabel(frame: CGRect.zero)
        self.addTarget(self, action: #selector(self.addFloatingLabel), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
    }
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
          return bounds.insetBy(dx: 12, dy: 0)
      }
      
      override open func editingRect(forBounds bounds: CGRect) -> CGRect {
          return bounds.insetBy(dx: 12, dy: 0)
      }
    // Add a floating label to the view on becoming first responder
    @objc func addFloatingLabel() {
        if self.text == "" {
            self.floatingLabel.alpha = 0
            self.floatingLabel.textColor = self.floatingLabelColor
            self.floatingLabel.font = self.floatingLabelFont
            self.floatingLabel.text = self._placeholder
            self.floatingLabel.layer.backgroundColor = UIColor.white.withAlphaComponent(0).cgColor
            self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
            self.floatingLabel.clipsToBounds = true
            self.floatingLabel.frame = CGRect(x: 0, y: 0, width: self.floatingLabel.frame.width+4, height: self.floatingLabel.frame.height+2)
            self.floatingLabel.textAlignment = .center
            UIView.animate(withDuration: 0.5) {
            self.addSubview(self.floatingLabel)
            self.layer.borderColor = self.activeBorderColor.cgColor
       
                self.layer.borderColor = UIColor.black.cgColor
            self.floatingLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -5).isActive = true // Place our label 10 pts above the text field
            }
            self.placeholder = ""
            
            }
        
        // Floating label may be stuck behind text input. we bring it forward as it was the last item added to the view heirachy
   UIView.animate(withDuration: 0.13) {
            self.bringSubviewToFront(self.subviews.last!)
            self.setNeedsDisplay()
            self.floatingLabel.alpha = 1
        }
    }
    
    @objc func removeFloatingLabel() {
        if self.text == "" {
            UIView.animate(withDuration: 0.13) {
                self.subviews.forEach{ $0.removeFromSuperview() }
                self.setNeedsDisplay()
            }
            self.placeholder = self._placeholder
        }
        self.layer.borderColor = Theme.accentColor?.cgColor
        self.floatingLabel.textColor = Theme.gradientColorDark
        
    }
    func addStartLabel(){
        if self.text != "" {
                 self.floatingLabel.alpha = 0
                 self.floatingLabel.textColor = self.floatingLabelColor
                 self.floatingLabel.font = self.floatingLabelFont
                 self.floatingLabel.text = self._placeholder
                 self.floatingLabel.layer.backgroundColor = UIColor.white.withAlphaComponent(0).cgColor
                 self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
                 self.floatingLabel.clipsToBounds = true
                 self.floatingLabel.frame = CGRect(x: 0, y: 0, width: self.floatingLabel.frame.width+4, height: self.floatingLabel.frame.height+2)
                 self.floatingLabel.textAlignment = .center
                 UIView.animate(withDuration: 0.5) {
                 self.addSubview(self.floatingLabel)
                 self.layer.borderColor = self.activeBorderColor.cgColor
            
                     self.layer.borderColor = UIColor.black.cgColor
                 self.floatingLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -5).isActive = true // Place our label 10 pts above the text field
                 }
                 self.placeholder = ""
                 
                 }
             
             // Floating label may be stuck behind text input. we bring it forward as it was the last item added to the view heirachy
        UIView.animate(withDuration: 0.13) {
                 self.bringSubviewToFront(self.subviews.last!)
                 self.setNeedsDisplay()
                 self.floatingLabel.alpha = 1
             }
    }
    func addViewPasswordButton() {
        self.button.setImage(UIImage(named: "ic_reveal"), for: .normal)
        self.button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.button.frame = CGRect(x: 0, y: 16, width: 22, height: 16)
        self.button.clipsToBounds = true
        self.rightView = self.button
        self.rightViewMode = .always
        self.button.addTarget(self, action: #selector(self.enablePasswordVisibilityToggle), for: .touchUpInside)
    }
    
    func addImage(image: UIImage){
        
        self.imageView.image = image
        self.imageView.frame = CGRect(x: 20, y: 0, width: 20, height: 20)
        self.imageView.translatesAutoresizingMaskIntoConstraints = true
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        
        DispatchQueue.main.async {
            self.leftView = self.imageView
            self.leftViewMode = .always
        }
        
    }
    
    @objc func enablePasswordVisibilityToggle() {
        isSecureTextEntry.toggle()
        if isSecureTextEntry {
            self.button.setImage(UIImage(named: "ic_show"), for: .normal)
        }else{
            self.button.setImage(UIImage(named: "ic_hide"), for: .normal)
        }
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
            self.textColor = Theme.gradientColorDark
            self.font = UIFont(name: Theme.mainFontName, size: 20)
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
        
        backgroundColor = Theme.gradientColorDark
        layer.cornerRadius = frame.height / 2
        setTitleColor(UIColor.white, for: .normal)
    }
}
class DotViewUtility: UIView{
    override func draw(_ rect: CGRect) {
        backgroundColor = Theme.gradientColorLight
   //     layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
      //  layer.shadowColor = UIColor.darkGray.cgColor
        layer.cornerRadius = 10
        borderWidth = 1
        borderColor = .black
    }
}


