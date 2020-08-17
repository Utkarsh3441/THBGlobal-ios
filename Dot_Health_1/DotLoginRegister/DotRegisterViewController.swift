//
//  RegisterViewController.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 05/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit
import LBTATools
import SVProgressHUD
import TinyConstraints
class DotRegisterViewController: LBTAFormController {
    var countryTextField = UITextField()
    var stateTextField = UITextField()
    var genderTextField = UITextField()
    var password = UITextField()
    var confirmPassword = UITextField()
    var names = ["",""]
    static let shared = DotRegisterViewController()
    var RegisterModels :registerModel?
    let signUpButton = UIButton(title: "Sign Up", titleColor: .white, font: .boldSystemFont(ofSize: 16), backgroundColor: Theme.gradientColorDark!, target: self, action: #selector(handleRegister))
    let cancelButton = UIButton(title: "", titleColor: .white, font: .boldSystemFont(ofSize: 16), backgroundColor: .clear, target: self, action: nil)
    var registerItems = ["Name","Email-ID","Country","State","City","Address 1","Address 2","Mobile No","Gender","Date Of Birth","Password","Confirm Password","Referal Code","Pincode"]
    var doubleRegisterItems = ["First Name","Last Name","Ext","Mobile No"]
    var validationDict = [String:Any]()
    var heightCons : CGFloat = 0.0
    private let client = DotConnectionClient()
    var progress = SVProgressHUD()
//    var parameters = ["patient_name":"animesh","patient_dob":"17-10-1998","patient_gender":"male","patient_email":"ani@gmail.com","patient_mobile":"123456789","patient_password":"123","patient_refcode":"AE9384SE","patient_address1":"test","patient_address2":"test1","patient_city","patient_state",patient_country,patient_pincode]
    var parameters1 = [String:Any]()
    var genders = ["male","female","other"]
    var states = [
    
        "Andaman and Nicobar Islands",
        "Andhra Pradesh",
        "Arunachal Pradesh",
        "Assam",
        "Bihar",
        "Chandigarh",
        "Chhattisgarh",
        "Dadra and Nagar Haveli",
        "Daman and Diu",
        "Delhi",
        "Goa",
        "Gujarat",
        "Haryana",
        "Himachal Pradesh",
        "Jammu and Kashmir",
        "Jharkhand",
        "Karnataka",
        "Kerala",
        "Ladakh",
        "Lakshadweep",
        "Madhya Pradesh",
        "Maharashtra",
        "Manipur",
        "Meghalaya",
        "Mizoram",
        "Nagaland",
        "Odisha",
        "Puducherry",
       "Punjab",
        "Rajasthan",
        "Sikkim",
        "Tamil Nadu",
        "Telangana",
        "Tripura",
        "Uttar Pradesh",
        "Uttarakhand",
      "West Bengal"
    ]
    let countryPicker = UIPickerView()
    let statePicker = UIPickerView()
    let genderPicker = UIPickerView()
    let countryList = Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }
    var stateList : [String]?
    var toolBar = UIToolbar()
    var footer = UIView(backgroundColor: UIColor.white.withAlphaComponent(0.8))
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    @objc fileprivate func handleRegister() {
         register()
       }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Enter Details"
        navigationController?.navigationBar.tintColor = Theme.backgroundColor
       }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightCons = 40
        scrollView.alwaysBounceVertical = true
        view.backgroundColor = UIColor(hex: "#d8e5e2")
        formContainerStackView.axis = .vertical
        formContainerStackView.spacing = 12
        formContainerStackView.layoutMargins = .init(top: 25, left: 24, bottom: 30, right: 24)
//        formContainerStackView.backgroundColor = .white
//        view.backgroundColor = UIColor.white.withAlphaComponent(1)
        view.addSubview(footer)
        footer.edges(to: view, excluding: .top, insets: .bottom(0), isActive: true)
        footer.constrainHeight(100)
        
        footer.addSubview(signUpButton)
        signUpButton.edges(to: footer, insets: .bottom(25) + .top(25) + .right(20) + .left(20), isActive: true)
        signUpButton.layer.cornerRadius = 4
        signUpButton.constrainHeight(50)
        (0...registerItems.count-1).forEach { (i) in
            
            if i == 0{
                let tf1 = FloatingLabelInput(placeholder: "Name", cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .white,height: heightCons)
              
             
                tf1.delegate = self
               
                tf1.addDoneButton(title: "DONE", target: self, selector: #selector(tapDone(sender:)))
                
                
                tf1.accessibilityIdentifier = "Name"
               
                formContainerStackView.addArrangedSubview(tf1)
            }
            else if i == 7{
                let tf1 = FloatingLabelInput(placeholder: "+91", cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .white,height: 60)
                
                let tf2 = FloatingLabelInput(placeholder: "Mobile No", cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .white, height: 60)
                tf2.accessibilityIdentifier = "Mobile No"
                tf2.delegate = self
                tf1.isEnabled = false
                tf2.addDoneButton(title: "DONE", target: self, selector: #selector(tapDone(sender:)))
                let buttonsStackViewa = UIStackView(arrangedSubviews: [tf1, tf2])
                tf1.constrainWidth(55)
                tf2.constrainWidth(view.frame.width - 55)
                buttonsStackViewa.constrainHeight(heightCons)
                buttonsStackViewa.spacing = 12
                formContainerStackView.addArrangedSubview(buttonsStackViewa)

            }
            else if registerItems[i] == "Country" {
                
                let tf = FloatingLabelInput(placeholder: registerItems[i], cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .white,height: heightCons)
                tf.delegate = self
                tf.accessibilityIdentifier = "Country"
                
                countryPicker.delegate = self
                tf.inputView = countryPicker
                countryPicker.backgroundColor = UIColor.white
                countryTextField = tf
                formContainerStackView.addArrangedSubview(countryTextField)
            }
            else if registerItems[i] == "State" {
                    
                    let tf = FloatingLabelInput(placeholder: registerItems[i], cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .white,height: heightCons)
                    tf.delegate = self
                    statePicker.delegate = self
                    tf.accessibilityIdentifier = "State"
                    
                    tf.inputView = statePicker
                    statePicker.backgroundColor = UIColor.white
                    stateTextField = tf
                    formContainerStackView.addArrangedSubview(stateTextField)
                }
                else if registerItems[i] == "Gender" {
                    
                    let tf = FloatingLabelInput(placeholder: registerItems[i], cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .white,height: heightCons)
                    tf.delegate = self
                    genderPicker.delegate = self
                    tf.accessibilityIdentifier = "Gender"
                    
                    tf.inputView = genderPicker
                    genderPicker.backgroundColor = UIColor.white
                    genderTextField = tf
                    formContainerStackView.addArrangedSubview(genderTextField)
                }
                else if registerItems[i] == "Date Of Birth" {
        
                    let tf = FloatingLabelInput(placeholder: registerItems[i], cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .white,height: heightCons)
                    tf.delegate = self
                    tf.accessibilityIdentifier = "dob"
                    formContainerStackView.addArrangedSubview(tf)
                }
                else if registerItems[i] == "Password" {
                    
                    let tf = FloatingLabelInput(placeholder: registerItems[i], cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .white,height: heightCons)
                    tf.delegate = self
                    tf.accessibilityIdentifier = "Password"
                    tf.addDoneButton(title: "DONE", target: self, selector: #selector(tapDone(sender:)))
                    password = tf
                    formContainerStackView.addArrangedSubview(tf)
                }
                else if registerItems[i] == "Confirm Password" {
                    
                    let tf = FloatingLabelInput(placeholder: registerItems[i], cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .white,height: heightCons)
                    tf.delegate = self
                    tf.accessibilityIdentifier = "Confirm Password"
                    tf.addDoneButton(title: "DONE", target: self, selector: #selector(tapDone(sender:)))
                    confirmPassword = tf
                    formContainerStackView.addArrangedSubview(tf)
                }
            else{
                 let tf = FloatingLabelInput(placeholder: registerItems[i], cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .white,height: heightCons)
                tf.accessibilityIdentifier = registerItems[i]
                tf.addDoneButton(title: "DONE", target: self, selector: #selector(tapDone(sender:)))
                formContainerStackView.addArrangedSubview(tf)
                 tf.delegate = self
            }
            
            
        }
        formContainerStackView.addArrangedSubview(cancelButton)
        formContainerStackView.spacing = 25
//        signUpButton.constrainHeight(heightCons)
        createToolbar()

    }
    @objc func tapDone(sender: FloatingLabelInput) {
             view.endEditing(true)
    }
    func createToolbar()
      {
          toolBar = UIToolbar(frame: CGRect())
          toolBar.sizeToFit()
          
          //Customizations
        toolBar.barTintColor = Theme.accentColor
          toolBar.tintColor = .white
          
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(DotRegisterViewController.closePickerView))
          
          toolBar.setItems([doneButton], animated: false)
          toolBar.isUserInteractionEnabled = true
          
          stateTextField.inputAccessoryView = toolBar
          genderTextField.inputAccessoryView = toolBar
          countryTextField.inputAccessoryView = toolBar
      }
    func pushView()->UIViewController
       {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let registerFacilityVC = storyboard.instantiateViewController(withIdentifier: "mainTab") as! DotTabViewController
           return registerFacilityVC
       }
       func showAlertController()
       {
           //simple alert dialog
           let alertController = UIAlertController(title: "Terms and Conditions", message: "Terms of service are the legal agreements between a service provider and a person who wants to use that service. The person must agree to abide by the terms of service in order to use the offered service. Terms of service can also be merely a disclaimer, especially regarding the use of websites", preferredStyle: UIAlertController.Style.alert);
           
           // Add Action
           alertController.addAction(UIAlertAction(title: "Accept", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
               // write after register Logic

               self.navigationController?.pushViewController(self.pushView(), animated: true)
               self.navigationController?.setNavigationBarHidden(true, animated: true)
              
           }));
           // Cancel button
           let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
           alertController.addAction(cancel)
           self.present(alertController, animated: false, completion: { () -> Void in

               })
       }
    @objc func closePickerView()
    {
        
//        getStates(country: countryTextField.text ?? "")
        view.endEditing(true)
    }
    @objc func addFloatingLabe(){
        print(":123")
    }
    // MARK:- API Calls
        
        func register() {
            if !validationDict.isEmpty || !(parameters1.count == (registerItems.count-1)){
                showAlertView("Invalid Entries", message: "Please enter valid inputs")
                return
            }
          
            // Query item
            let queryItem = [ URLQueryItem(name: "keyName", value: "ValueName") ]
            guard let body = try? JSONSerialization.data(withJSONObject: parameters1) else { return }
           
            
            // Headers
            let headers = ["Content-Type":"application/json"]
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.custom)
            let api: API = .api1
            let endpoint: Endpoint = api.getPostAPIEndpoint(urlString: "\(api.rawValue)patients", queryItems: queryItem, headers: headers, body: body)
            
            client.registerUser(from: endpoint) { [weak self] result in
                guard let self = self else { return }
                SVProgressHUD.dismiss()
                switch result {
                
                case .success(let model2Result):
        
                    guard let model2Result = model2Result else { return }
                    if let dataModel = model2Result as? NSDictionary ,let type = dataModel["type"] as? String,let desc = dataModel["description"] as? String{
                        switch type{
                        case "info":
                            do {
                                DotRegisterViewController.shared.RegisterModels = try JSONDecoder().decode(registerModel.self, from: body)
                            } catch  {
                                print(error.localizedDescription)
                            }
                        default:
                            self.showAlertView("Registration Failed", message: desc)
                        }
                    }
                    else{
                        self.showAlertView("Registration Failed", message: "Some Error Occured")
                    }
                    print(model2Result)
                case .failure(let error):
                   
                    print("the error \(error)")
                }
            }
        }
     func isValid(login: String?) -> Bool {
        let characterSet = CharacterSet.whitespaces
        let trimmedText = login?.trimmingCharacters(in: characterSet)
        let regularExtension = LoginNameRegularExtention.passord
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExtension)
        let isValid: Bool = predicate.evaluate(with: trimmedText)
        return isValid
    }
    func validateEmail(email:String) -> Bool {
        let emailRegex = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
extension DotRegisterViewController:UITextFieldDelegate{
    
      
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        countryPicker.reloadAllComponents()
        statePicker.reloadAllComponents()
        if textField.accessibilityIdentifier == "dob"{
            textField.openDatePicker(modeType: .date)
               }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        var customField = textField as? FloatingLabelInput
        switch textField.accessibilityIdentifier {
        case "Name":
            if let val = textField.text{
                if val == kblankString{
                  validationDict["patient_name"] = "yes"
                    customField?.floatingLabelColor = .systemRed
                    customField?.borderWidth = 1
                    customField?.borderColor = .systemRed
                }
                else{
                    validationDict.removeValue(forKey: "patient_name")
                    customField?.floatingLabelColor = .darkGray
                    customField?.borderWidth = 0
                    parameters1["patient_name"] = val
                }
                
            }
        case "Last Name":
            if let val = textField.text{
                if val == kblankString{
                    names[1] = ""
                    customField?.floatingLabelColor = .systemRed
                    customField?.borderWidth = 1
                    customField?.borderColor = .systemRed
                }
                    
                else{
                    names[1] = val
                    customField?.floatingLabelColor = .darkGray
                    customField?.borderWidth = 0
                    parameters1["patient_name"] = val
                }
            }
        case "Email-ID":
            if let val = textField.text,validateEmail(email: val){
                parameters1["patient_email"] = val
                customField?.floatingLabelColor = .darkGray
                customField?.borderWidth = 0
                validationDict.removeValue(forKey: "email")
            }
            else{
                customField?.floatingLabelColor = .systemRed
                customField?.borderWidth = 1
                customField?.borderColor = .systemRed
                validationDict["email"] = "yes"
            }
        case "Country":
            if let val = textField.text{
                if !countryList.contains(val){
                    customField?.floatingLabelColor = .systemRed
                    customField?.borderWidth = 1
                    customField?.borderColor = .systemRed
                    validationDict["country"] = "yes"
                    
                }
                else{
                    customField?.floatingLabelColor = .darkGray
                    customField?.borderWidth = 0
                    parameters1["patient_country"] = val
                    validationDict.removeValue(forKey: "country")
                }
                
            }
        case "Password":
            if let val = textField.text,isValid(login: val){
                parameters1["patient_password"] = val
                validationDict.removeValue(forKey: "password")
                customField?.floatingLabelColor = .darkGray
                customField?.borderWidth = 0
                if val == confirmPassword.text{
                    (confirmPassword as? FloatingLabelInput)?.floatingLabelColor = .darkGray
                    (confirmPassword as? FloatingLabelInput)?.borderWidth = 0
                }
                else{
                    (confirmPassword as? FloatingLabelInput)?.floatingLabelColor = .systemRed
                    (confirmPassword as? FloatingLabelInput)?.borderWidth = 1
                    (confirmPassword as? FloatingLabelInput)?.borderColor = .systemRed
                    
                    
                }
            }
            else{
                customField?.floatingLabelColor = .systemRed
                customField?.borderWidth = 1
                customField?.borderColor = .systemRed
                validationDict["password"] = "yes"
            }
        case "Confirm Password":
            if let val = textField.text,isValid(login: val), parameters1["patient_password"] as? String == val{
                customField?.floatingLabelColor = .darkGray
                customField?.borderWidth = 0
                validationDict.removeValue(forKey: "Confirm Password")
            }
            else{
                customField?.floatingLabelColor = .systemRed
                customField?.borderWidth = 1
                customField?.borderColor = .systemRed
                validationDict["Confirm Password"] = "yes"
                
            }
        case "Pincode":
            if let val = textField.text,val.count == 6{
                if Int(val) != nil{
                    parameters1["patient_pincode"] = val
                    validationDict.removeValue(forKey: "pincode")
                    customField?.floatingLabelColor = .darkGray
                    customField?.borderWidth = 0
                }
                else{
                    customField?.floatingLabelColor = .systemRed
                    customField?.borderWidth = 1
                    customField?.borderColor = .systemRed
                    validationDict["pincode"] = "yes"
                }
            }
            else{
                customField?.floatingLabelColor = .systemRed
                customField?.borderWidth = 1
                customField?.borderColor = .systemRed
                validationDict["pincode"] = "yes"
            }
        case "Address 2":
            if let val = textField.text,val != kblankString{
                     parameters1["patient_address2"] = val
                    customField?.floatingLabelColor = .darkGray
                    customField?.borderWidth = 0
                    validationDict.removeValue(forKey: "address2")
            }else{
                   
                validationDict["address2"] = "yes"
                customField?.floatingLabelColor = .systemRed
                customField?.borderWidth = 1
                customField?.borderColor = .systemRed
                }
                
            
        case "Address 1":
            if let val = textField.text,val != kblankString{
                                parameters1["patient_address1"] = val
                validationDict.removeValue(forKey: "address1")
                               customField?.floatingLabelColor = .darkGray
                               customField?.borderWidth = 0
                       }else{
                              
                           validationDict["address1"] = "yes"
                           customField?.floatingLabelColor = .systemRed
                           customField?.borderWidth = 1
                           customField?.borderColor = .systemRed
                           }

        case "State":
            if let val = textField.text{
                if !states.contains(val){
                    customField?.floatingLabelColor = .systemRed
                    customField?.borderWidth = 1
                    customField?.borderColor = .systemRed
                    validationDict["state"] = "yes"
                }
                else{
                    customField?.floatingLabelColor = .darkGray
                    customField?.borderWidth = 0
                    parameters1["patient_state"] = val
                    validationDict.removeValue(forKey: "state")
                }
            }
        case "City":
            if let val = textField.text,val != kblankString{
                     parameters1["patient_city"] = val
                    customField?.floatingLabelColor = .darkGray
                    customField?.borderWidth = 0
                validationDict.removeValue(forKey: "city")
            }else{
                validationDict["city"] = "yes"
                customField?.floatingLabelColor = .systemRed
                customField?.borderWidth = 1
                customField?.borderColor = .systemRed
                }
            
        case "Gender":
            if let val = textField.text{
                if !genders.contains(val){
                    validationDict["gender"] = "yes"
                    customField?.floatingLabelColor = .systemRed
                    customField?.borderWidth = 1
                    customField?.borderColor = .systemRed
                }
                else{
                    parameters1["patient_gender"] = val
                        customField?.floatingLabelColor = .darkGray
                        customField?.borderWidth = 0
                    validationDict.removeValue(forKey: "gender")
                }
            }
        case "Referal Code":
            if let val = textField.text,val != kblankString{
                                parameters1["patient_refcode"] = val
                               customField?.floatingLabelColor = .darkGray
                               customField?.borderWidth = 0
                validationDict.removeValue(forKey: "ref")
                       }else{
                              
                           validationDict["ref"] = "yes"
                           customField?.floatingLabelColor = .systemRed
                           customField?.borderWidth = 1
                           customField?.borderColor = .systemRed
                           }
        case "dob":
            if let val = textField.text{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                if let date = dateFormatter.date(from: val),Date() >= date{
                    parameters1["patient_dob"] = val
                    validationDict.removeValue(forKey: "dob")
                    customField?.floatingLabelColor = .darkGray
                    customField?.borderWidth = 0
                }
                else{
                    customField?.floatingLabelColor = .systemRed
                    customField?.borderWidth = 1
                    customField?.borderColor = .systemRed
                    
                    validationDict["dob"] = "yes"
                }
            }
        case "Mobile No":
            if let val = textField.text,val.count == 10{
                customField?.floatingLabelColor = .darkGray
                customField?.borderWidth = 0
                parameters1["patient_mobile"] = "+91-" + val
                validationDict.removeValue(forKey: "phone")
            }
            else{
                customField?.floatingLabelColor = .systemRed
                customField?.borderWidth = 1
                customField?.borderColor = .systemRed
                validationDict["phone"] = "yes"
            }
        default:
            print("error")
        }
    }
}
extension DotRegisterViewController:UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == statePicker{
            return states.count
        }
        else if pickerView == genderPicker{
            return genders.count
        }
            return countryList.count
        
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
       {
           if pickerView == statePicker{
            return states[row]
                  }
         else if pickerView == genderPicker{
             return genders[row]
         }
               return countryList[row]
           
       
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == statePicker {
            stateTextField.text = states[row]
        }
        else if pickerView == genderPicker{
            genderTextField.text = genders[row]
            }
        else{
            countryTextField.text =  countryList[row]
        }
               
       }
       

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

      var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = Theme.accentColor
        label.textAlignment = .center
        label.font = UIFont(name: "Menlo-Regular", size: 17)
        if pickerView == statePicker {
            if states.isEmpty  {
                pickerView.isHidden = true
            }
            label.text = states[row]
        }
        else if pickerView == genderPicker{
                label.text = genders[row]
            }
        else{
            label.text = countryList[row]
        }
        
        return label
        
    }
       
    
}
