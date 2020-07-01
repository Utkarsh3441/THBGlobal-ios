//
//  RegisterViewController.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 05/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class DotRegisterViewController: UIViewController {

    @IBOutlet weak var firstName:UITextField!
     @IBOutlet weak var secondName:UITextField!
     @IBOutlet weak var email:UITextField!
     @IBOutlet weak var password:UITextField!
     @IBOutlet weak var ConfirmPassword:UITextField!
     @IBOutlet weak var country:UITextField!
     @IBOutlet weak var reference:UITextField!
     @IBOutlet weak var mobileNumber:UITextField!
     @IBOutlet weak var extensionNumber:UITextField!
    let countryPicker = UIPickerView()
    let countryList = Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        createToolbar()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    @IBAction func register(_ sender:UIButton){
        showAlertController()
    }
    func showAlertController()
    {
        //simple alert dialog
        let alertController = UIAlertController(title: "Terms and Conditions", message: "Terms of service are the legal agreements between a service provider and a person who wants to use that service. The person must agree to abide by the terms of service in order to use the offered service. Terms of service can also be merely a disclaimer, especially regarding the use of websites", preferredStyle: UIAlertController.Style.alert);
        
        // Add Action
        alertController.addAction(UIAlertAction(title: "Accept", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            // write after register Logic
           
        }));
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alertController.addAction(cancel)
        self.present(alertController, animated: false, completion: { () -> Void in

            })
    }
      func createPickerView()
      {
          countryPicker.delegate = self
          country.delegate = self
          country.inputView = countryPicker
          countryPicker.backgroundColor = UIColor.white
      }
    

      
      func createToolbar()
      {
          let toolBar = UIToolbar(frame: CGRect())
          toolBar.sizeToFit()
          
          //Customizations
        toolBar.barTintColor = Theme.tintcolor
          toolBar.tintColor = .white
          
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(DotRegisterViewController.closePickerView))
          
          toolBar.setItems([doneButton], animated: false)
          toolBar.isUserInteractionEnabled = true
          
          country.inputAccessoryView = toolBar
      }
    @objc func closePickerView()
    {
        view.endEditing(true)
    }

}
extension DotRegisterViewController:UITextFieldDelegate{
    
      
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        countryPicker.reloadAllComponents()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
extension DotRegisterViewController:UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        countryList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
       {
           
         
               return countryList[row]
           
       
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          
               country.text =  countryList[row]
               
       }
       

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

      var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = Theme.tintcolor
        label.textAlignment = .center
        label.font = UIFont(name: "Menlo-Regular", size: 17)
        
        label.text = countryList[row]
        
        return label
        
    }
       
    
}

