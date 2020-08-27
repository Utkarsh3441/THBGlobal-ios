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

enum RegistrationFields: String, CaseIterable {
    case Name
    case Email = "Email-ID"
    case Address1 = "Home/Flat Number"
    case Address2 = "Locality"
    case City
    case Pincode
    case State
    case Country
    case Mobile = "Mobile No"
    case Gender
    case DOB = "Date Of Birth"
    case Password
    case ConfirmPassword = "Confirm Password"
    case ReferalCode = "Referal Code (Optional)"
}



class DotRegisterViewController: LBTAFormController {
    var countryTextField = UITextField()
    var stateTextField = UITextField()
    var genderTextField = UITextField()
    var password = UITextField()
    var confirmPassword = UITextField()
    var names = ["",""]
    static let shared = DotRegisterViewController()
    var RegisterModels :registerModel?
    var registrationSuccess:RegistrationSuccessModel?
    let signUpButton = UIButton(title: "Sign Up", titleColor: .white, font: .boldSystemFont(ofSize: 16), backgroundColor: Theme.gradientColorDark!, target: self, action: #selector(handleRegister))
    let cancelButton = UIButton(title: "", titleColor: .white, font: .boldSystemFont(ofSize: 16), backgroundColor: .clear, target: self, action: nil)
    var registerItems = [String]()
    //["Name","Email-ID","Country","State","City","Address 1","Address 2","Mobile No","Gender","Date Of Birth","Password","Confirm Password","Referal Code (Optional)","Pincode"]
    var doubleRegisterItems = ["First Name","Last Name","Ext","Mobile No"]
    var validationDict = [String:Any]()
    var heightCons : CGFloat = 0.0
    private let client = DotConnectionClient()
    var progress = SVProgressHUD()
//    var parameters = ["patient_name":"animesh","patient_dob":"17-10-1998","patient_gender":"male","patient_email":"ani@gmail.com","patient_mobile":"123456789","patient_password":"123","patient_refcode":"AE9384SE","patient_address1":"test","patient_address2":"test1","patient_city","patient_state",patient_country,patient_pincode]
    var parameters1 = [String:Any]()
    var genders = ["Male","Female","Other"]
    var countryList = ["India","United Arab Emirates"]
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
     var unchecked = true
    let countryPicker = UIPickerView()
    let statePicker = UIPickerView()
    let genderPicker = UIPickerView()
   // let countryList = Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }
    var stateList : [String]?
    var toolBar = UIToolbar()
    var footer = UIView(backgroundColor: UIColor.white.withAlphaComponent(0.8))
    var checkBoxView = UIView(backgroundColor: .clear)
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    @objc fileprivate func handleRegister() {
         register()
       }
    @objc fileprivate func handleAgreement(sender:UIButton) {
           if unchecked {
               sender.setImage(UIImage(systemName:"checkmark.square.fill"), for: .normal)
               unchecked = false
           }
           else {
               sender.setImage( UIImage(systemName:"checkmark.square"), for: .normal)
               unchecked = true
           }
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
        let Check = UIButton(title: "", titleColor: .white, font: .boldSystemFont(ofSize: 16), backgroundColor: .clear, target: self, action: #selector(handleAgreement))
        Check.tintColor = Theme.gradientColorLight
        Check.setImage( UIImage(systemName:"checkmark.square"), for: .normal)
        let lab = UITextView()
        lab.isEditable = false;
        lab.dataDetectorTypes = UIDataDetectorTypes.all
        lab.backgroundColor = .clear
        for value in RegistrationFields.allCases {
            registerItems.append(value.rawValue)
        }
        let attributedString = NSMutableAttributedString().createAttributedString(first:"I agree to the Asha's Terms Of Service & Privacy Policy", second: "", fColor: .darkGray, sColor: .white, fBold: true, sBold: false, fSize: 14, sSize: 0)
        let linkSet1 = attributedString.setAsLink(textToFind: "Privacy Policy", linkURL:  "https://www.ashacares.com/privacy-policy")
        let linkSet2 = attributedString.setAsLink(textToFind: "Terms Of Service", linkURL:  "https://www.ashacares.com/terms-of-use")
        if linkSet1 && linkSet2 {
            lab.attributedText = attributedString
        }
        checkBoxView.addSubview(Check)
        checkBoxView.addSubview(lab)
        Check.edges(to: checkBoxView, insets: .bottom(5) + .top(5) + .left(2), isActive: true)
        
        lab.edges(to: checkBoxView, insets: .bottom(5) + .top(7) + .right(5) + .left(35), isActive: true)
        Check.rightToLeft(of: lab)
        footer.addSubview(signUpButton)
        signUpButton.edges(to: footer, insets: .bottom(25) + .top(25) + .right(20) + .left(20), isActive: true)
        signUpButton.layer.cornerRadius = 4
        signUpButton.constrainHeight(50)
        (0...registerItems.count-1).forEach { (i) in
            
            if registerItems[i] == RegistrationFields.Name.rawValue{
                let tf1 = FloatingLabelInput(placeholder: "Name", cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .white,height: heightCons)
                
                
                tf1.delegate = self
                
                tf1.addDoneButton(title: "DONE", target: self, selector: #selector(tapDone(sender:)))
                
                
                tf1.accessibilityIdentifier = "Name"
                
                formContainerStackView.addArrangedSubview(tf1)
            }
            else if registerItems[i] == RegistrationFields.Mobile.rawValue{
                
                addMobileNumberTextField()
                
                
            }
            else if registerItems[i] == RegistrationFields.Country.rawValue {
                
                let tf = FloatingLabelInput(placeholder: registerItems[i], cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .white,height: heightCons)
                tf.delegate = self
                tf.accessibilityIdentifier = "Country"
                
                countryPicker.delegate = self
                tf.inputView = countryPicker
                countryPicker.backgroundColor = UIColor.white
                countryTextField = tf
                formContainerStackView.addArrangedSubview(countryTextField)
            }
            else if registerItems[i] == RegistrationFields.State.rawValue {
                
                addStateTextField()
            }
            else if registerItems[i] == RegistrationFields.Gender.rawValue {
                
                let tf = FloatingLabelInput(placeholder: registerItems[i], cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .white,height: heightCons)
                tf.delegate = self
                genderPicker.delegate = self
                tf.accessibilityIdentifier = "Gender"
                
                tf.inputView = genderPicker
                genderPicker.backgroundColor = UIColor.white
                genderTextField = tf
                formContainerStackView.addArrangedSubview(genderTextField)
            }
            else if registerItems[i] == RegistrationFields.DOB.rawValue {
                
                let tf = FloatingLabelInput(placeholder: registerItems[i], cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .white,height: heightCons)
                tf.delegate = self
                tf.accessibilityIdentifier = RegistrationFields.DOB.rawValue
                formContainerStackView.addArrangedSubview(tf)
            }
            else if registerItems[i] == RegistrationFields.Password.rawValue {
                
                addPasswordTextField()
               
            }
            else if registerItems[i] == RegistrationFields.ConfirmPassword.rawValue {
                
                let tf = FloatingLabelInput(placeholder: registerItems[i], cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .white,height: heightCons)
                tf.delegate = self
                tf.accessibilityIdentifier = "Confirm Password"
                tf.addDoneButton(title: "DONE", target: self, selector: #selector(tapDone(sender:)))
                tf.isSecureTextEntry = true
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
        formContainerStackView.addArrangedSubview(checkBoxView)
        formContainerStackView.addArrangedSubview(cancelButton)
        
        checkBoxView.constrainHeight(52)
        formContainerStackView.spacing = 25
        //        signUpButton.constrainHeight(heightCons)
        createToolbar()
        
    }
    
    func addMobileNumberTextField() {
        let tf1 = FloatingLabelInput(placeholder: selectedCountryIsIndia() ? "+91" : "+971", cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .white,height: 60)
        
        let tf2 = FloatingLabelInput(placeholder: "Mobile No", cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .white, height: 60)
        tf1.accessibilityIdentifier = "Country Code"
        tf2.accessibilityIdentifier = "Mobile No"
        tf2.delegate = self
        tf1.isEnabled = false
        tf2.addDoneButton(title: "DONE", target: self, selector: #selector(tapDone(sender:)))
        let buttonsStackViewa = UIStackView(arrangedSubviews: [tf1, tf2])
        tf1.constrainWidth(70)
        tf2.constrainWidth(view.frame.width - 70)
        buttonsStackViewa.constrainHeight(heightCons)
        buttonsStackViewa.spacing = 12
        buttonsStackViewa.tag = 100
        formContainerStackView.addArrangedSubview(buttonsStackViewa)
    }
    func addStateTextField(){
        let tf = FloatingLabelInput(placeholder: RegistrationFields.State.rawValue, cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .white,height: heightCons)
        tf.delegate = self
        tf.accessibilityIdentifier = "State"
         tf.addDoneButton(title: "DONE", target: self, selector: #selector(tapDone(sender:)))
        if  selectedCountryIsIndia()
        {
            statePicker.delegate = self
            tf.inputView = statePicker
            statePicker.backgroundColor = UIColor.white
            stateTextField = tf
            stateTextField.tag = 101
            formContainerStackView.addArrangedSubview(stateTextField)
        }
        else {
           
            tf.tag = 101
            formContainerStackView.addArrangedSubview(tf)
        }
    }
    func addPasswordTextField () {
        
        let tf = FloatingLabelInput(placeholder: RegistrationFields.Password.rawValue, cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .white,height: heightCons)
        tf.delegate = self
        tf.accessibilityIdentifier = "Password"
        tf.addDoneButton(title: "DONE", target: self, selector: #selector(tapDone(sender:)))
        tf.isSecureTextEntry = true
        password = tf
        
        let infobutton = UIButton(image: UIImage(named: "info.png")!, target: self, action: #selector(infoBtnTapped))
              
        let buttonsStackViewa = UIStackView(arrangedSubviews: [tf, infobutton])
        tf.constrainWidth(view.frame.width - 80)
        infobutton.constrainWidth(32)
        buttonsStackViewa.constrainHeight(heightCons)
        buttonsStackViewa.spacing = 12
        formContainerStackView.addArrangedSubview(buttonsStackViewa)
    }
    func updateStateTextField(){
        
        let indexOfState = registerItems.firstIndex(of: RegistrationFields.State.rawValue) ?? 6 // 0
        if let view =  formContainerStackView.viewWithTag(101) {
            view.removeFromSuperview()
            formContainerStackView.removeArrangedSubview(view)
            statePicker.removeFromSuperview()
        }
        
        let tf = FloatingLabelInput(placeholder: RegistrationFields.State.rawValue, cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .white,height: heightCons)
        tf.delegate = self
        tf.accessibilityIdentifier = "State"
         tf.addDoneButton(title: "DONE", target: self, selector: #selector(tapDone(sender:)))
        if  selectedCountryIsIndia()
        {
            statePicker.delegate = self
            tf.inputView = statePicker
            statePicker.backgroundColor = UIColor.white
            stateTextField = tf
            stateTextField.tag = 101
            formContainerStackView.insertArrangedSubview(stateTextField, at: indexOfState)
        }
        else {
           
            tf.tag = 101
            formContainerStackView.insertArrangedSubview(tf, at: indexOfState)
        }
    }
    
    
    @objc func infoBtnTapped(sender: UIButton) {
        showAlertView("Password should contain minimum 8 cahracters", message: "\n. Minimum 1 special character\n. Minimum 1 upper case character\n. Minimum 1 lower case character\n. Minimum 1 number")
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
    func selectedCountryIsIndia() -> Bool {
        if let country = parameters1["patient_country"] as? String, country == "India" {
            return true
        }
        return false
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
            if (parameters1.count < (registerItems.count-2)){
                showAlertView("Alert", message: "Please provide valid information.")
                return
            }
            if password.text != confirmPassword.text {
                showAlertView("Alert", message: "Please confirm your password.")
            }
            
            if unchecked{
                showAlertView("Information", message: "Please Accept Asha's Terms Of Service & Privacy Policy")
                return
            }
            if validationDict.isEmpty {
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
                    if let dataModel = model2Result as? NSDictionary ,let type = dataModel["type"] as? String,let desc = dataModel["description"] as? String,let message = dataModel["message"] as? String{
                        switch type{
                        case "Success":
                            do {
                            let alert = UIAlertController(title: message, message: desc, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (_) in
                                   self.navigationController?.popViewController(animated: true)

                                    }))
                                self.present(alert, animated: true, completion:nil)
                            }
                        case "info":
                            do {
                                DotRegisterViewController.shared.registrationSuccess = try JSONDecoder().decode(RegistrationSuccessModel.self, from: body)
                                
                                
                            } catch  {
                                print(error.localizedDescription)
                            }
                        default:
                            self.showAlertView(message, message: desc)
                          //  self.navigationController
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
            else {
                showAlertView("Alert", message: "Please provide valid information.")
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
        if textField.accessibilityIdentifier == RegistrationFields.Email.rawValue {
            textField.autocapitalizationType = .none
        }
        else {
            textField.autocapitalizationType = .sentences
        }
        if textField.accessibilityIdentifier == RegistrationFields.DOB.rawValue{
            textField.openDatePicker(modeType: .date)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var customField = textField as? FloatingLabelInput
        switch textField.accessibilityIdentifier {
        case  RegistrationFields.Name.rawValue:
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
        case RegistrationFields.Email.rawValue:
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
        case RegistrationFields.Country.rawValue:
            let previouslySelectedCountry:String? = parameters1["patient_country"] as? String
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
                
                if let view =  formContainerStackView.viewWithTag(100) {
                    for subView in view.subviews {
                        if subView.accessibilityIdentifier == "Country Code" {
                            if let txtField = subView as? UITextField {
                                txtField.placeholder = selectedCountryIsIndia() ? "+91" : "+971"
                            }
                        }
                    }
                    view.setNeedsLayout()
                }
                
                if previouslySelectedCountry != textField.text && previouslySelectedCountry != nil {
                    updateStateTextField()
                }
              
                
            }
        case RegistrationFields.Password.rawValue:
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
        case RegistrationFields.ConfirmPassword.rawValue:
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
        case RegistrationFields.Pincode.rawValue:
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
        case RegistrationFields.Address2.rawValue:
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
                
            
        case RegistrationFields.Address1.rawValue:
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

        case RegistrationFields.State.rawValue:
            if let val = textField.text{
                if !states.contains(val) && selectedCountryIsIndia(){
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
        case RegistrationFields.City.rawValue:
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
            
        case RegistrationFields.Gender.rawValue:
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
        case RegistrationFields.ReferalCode.rawValue:
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
        case RegistrationFields.DOB.rawValue:
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
        case RegistrationFields.Mobile.rawValue:
            if let val = textField.text,val.count == 10{
                customField?.floatingLabelColor = .darkGray
                customField?.borderWidth = 0
                parameters1["patient_mobile"] = selectedCountryIsIndia() ? "+91-" : "+971-" + val
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
