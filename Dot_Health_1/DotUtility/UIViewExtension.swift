//
//  UIViewExtension.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 11/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

extension UIView{

    func addShadowAndRoundedCorner() {
       layer.shadowOpacity = 1
       layer.shadowOffset = CGSize.zero
       layer.shadowColor = UIColor.darkGray.cgColor
       layer.cornerRadius = 10
    }

}

extension UIButton {

    func createFloatingActionButton() {
       backgroundColor = Theme.tintcolor
       layer.cornerRadius = frame.height / 2
       layer.shadowOpacity = 0.3
       layer.shadowRadius = 3
       layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    func createNormalButton(){
        backgroundColor = Theme.backgroundColor
        layer.cornerRadius = 0
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func createSelectedOptionButton() {
        backgroundColor = Theme.tintcolor
        self.setTitleColor(.white, for: .normal)
       layer.cornerRadius = 5
       layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
       layer.shadowOffset = CGSize(width: 0, height: 3)
       layer.shadowOpacity = 1.0
       layer.shadowRadius = 10.0
       layer.masksToBounds = false
    }
    func createOptionButton() {
       backgroundColor = .systemBackground
       layer.cornerRadius = 5
       clipsToBounds = true
       borderWidth = 1
       borderColor = .lightGray
       setTitleColor(.black, for: .normal)
       layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
       layer.shadowOffset = CGSize(width: 0, height: 3)
       layer.shadowOpacity = 1.0
       layer.shadowRadius = 10.0
       layer.masksToBounds = false
    }

}
extension UITextField{
    func openDatePicker(){
           let datePicker = UIDatePicker()
           datePicker.datePickerMode = .date
           self.inputView = datePicker
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.superview?.frame.width ?? 414, height: 44))
        
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelButtonAction))
           let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonAccion))
           let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           toolbar.setItems([cancelButton, flexibleButton, doneButton], animated: false)
           self.inputAccessoryView = toolbar
          // endDateTextField.inputAccessoryView = toolbar
       }
    @objc func cancelButtonAction(){
        self.resignFirstResponder()
    }
    @objc func doneButtonAccion(){
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .medium
        if let datePicker = self.inputView as? UIDatePicker{
            print(datePicker.date)
            self.text = dateFormater.string(from: datePicker.date)
            self.resignFirstResponder()
        }
    }
}
