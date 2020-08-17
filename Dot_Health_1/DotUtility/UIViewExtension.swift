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
       backgroundColor = Theme.gradientColorDark
       tintColor = Theme.tintcolor
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
        backgroundColor = Theme.accentColor
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
       layer.shadowOffset = CGSize(width: 0, height: 2)
       layer.shadowOpacity = 0.5
       layer.shadowRadius = 5.0
       layer.masksToBounds = false
    }

}
extension UITextField{
    
    func openDatePicker(modeType:UIDatePicker.Mode){
           let datePicker = UIDatePicker()
           datePicker.datePickerMode = modeType
            datePicker.backgroundColor = Theme.backgroundColor
        datePicker.set18YearValidation()
        datePicker.setValue(Theme.accentColor, forKey: "textColor")
        datePicker.perform(Selector(("setHighlightsToday:")), with:Theme.gradientColorDark, afterDelay: 0.5)
            self.inputView = datePicker
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.superview?.frame.width ?? 414, height: 44))
        
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelButtonAction))
           let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonAccion))
        if modeType == .date {
             doneButton.tag = 1
        } else{
            doneButton.tag = 2
        }
           let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           toolbar.setItems([cancelButton, flexibleButton, doneButton], animated: false)
           self.inputAccessoryView = toolbar
          // endDateTextField.inputAccessoryView = toolbar
       }
    @objc func cancelButtonAction(){
        self.resignFirstResponder()
    }
    @objc func doneButtonAccion(sender:UIBarButtonItem){
        let dateFormater = DateFormatter()
        if sender.tag == 2{
           dateFormater.dateFormat = "HH:mm"
        }
        else{
            dateFormater.dateStyle = .medium
        }
        
//        dateFormater.dateFormat = "HH:mm"
        if let datePicker = self.inputView as? UIDatePicker{
            print(datePicker.date)
            self.text = dateFormater.string(from: datePicker.date)
            self.resignFirstResponder()
        }
    }
    func addDoneButton(title: String, target: Any, selector: Selector) {

            let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                                  y: 0.0,
                                                  width: UIScreen.main.bounds.size.width,
                                                  height: 44.0))//1
            let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
            let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
            toolBar.setItems([flexible, barButton], animated: false)//4
            self.inputAccessoryView = toolBar//5
        }
    }

extension UIDatePicker {
func set18YearValidation() {
    let currentDate: Date = Date()
    var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!
    var components: DateComponents = DateComponents()
    components.calendar = calendar
    components.year = -18
    let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
    components.year = -150
    let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
    self.minimumDate = minDate
    self.maximumDate = currentDate
} }

extension UITextView {

    func addDoneButton(title: String, target: Any, selector: Selector) {

        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}

extension UIViewController{
    
    func hideDatePickerWhenTappedAround() {
           let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissDatePicker))
           tap.cancelsTouchesInView = false
           view.addGestureRecognizer(tap)
       }

       @objc func dismissDatePicker() {
//        print(self.view.subviews)
        for subView in self.view.subviews{
            if let subView = subView as? UIDatePicker{
                subView.removeFromSuperview()
            }
            if let subView = subView as? UIToolbar{
                subView.removeFromSuperview()
            }
        }
         
    }
    
}

