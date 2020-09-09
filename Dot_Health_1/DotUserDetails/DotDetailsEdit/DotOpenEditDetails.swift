//
//  DotOpenEditDetails.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 08/08/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation
import LBTATools
import SVProgressHUD
import TinyConstraints
@objc protocol editTableDelegate: NSObjectProtocol{

    func refreshTable(data: [String:AnyObject])
}
class DotOpenEditDetails: LBTAFormController {
    var heightCons : CGFloat = 0.0
    let client = DotConnectionClient()
    weak var delegate:editTableDelegate?
    var registerItems = ["Name","Date Of Birth","Address 1","Address 2","City","State","Country","Mobile No","Gender","Pincode","MemberShip Number(optional)","Emergency Contact Number(optional)"]
    var dataSort = ["patient_name","patient_dob","patient_address1","patient_address2","patient_city","patient_state","patient_country","patient_mobile","patient_gender","patient_pincode","membership_number","emergency_contact_number"]
    var optionalVals = ["membership_number","emergency_contact_number"]
    var editDetails = ["patient_name":"",
    "patient_dob":"",
    "patient_gender":"",
    "patient_mobile":"",
    "patient_password":"",
    "patient_address1":"",
    "patient_address2":"",
    "patient_city":"",
    "patient_state":"",
    "patient_pincode":"",
    "patient_country":"",
    "patient_refcode":"",
    "membership_number":"",
    "emergency_contact_name":"",
    "emergency_contact_number":"",
    "emergency_contact_relation":"",
    "photo":"",
    "allergies":[""],
    "insured":true,
    "insurance_company_name":"",
    "insurance_validity":"",
    "primary_health_issue":"",
    "parent_id":1,
    "verified":true,
    "verification_token":"",
    "verification_token_expiry":"",
    "status":""] as [String : Any]
    var countryTextField = UITextField()
    var stateTextField = UITextField()
    var genderTextField = UITextField()
    var validationDict = [String:Any]()
    var userData = [String:AnyObject]()
//    var registerItems:[String]?
    let saveButton = UIButton(title: "Save", titleColor: .white, font: .boldSystemFont(ofSize: 16), backgroundColor: Theme.gradientColorDark!, target: self, action: #selector(handleRegister))
       let cancelButton = UIButton(title: "", titleColor: .white, font: .boldSystemFont(ofSize: 16), backgroundColor: .green, target: self, action: nil)
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
    let countryPicker = UIPickerView()
    let statePicker = UIPickerView()
    let genderPicker = UIPickerView()
    var stateList : [String]?
    var toolBar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightCons = 40
        scrollView.alwaysBounceVertical = true
        view.backgroundColor = UIColor(hex: "#d8e5e2")
        formContainerStackView.axis = .vertical
        formContainerStackView.spacing = 12
        for (k,v) in (userData){
            editDetails[k] = v
        }
        formContainerStackView.layoutMargins = .init(top: 25, left: 24, bottom: 30, right: 24)
        //        formContainerStackView.backgroundColor = .white
        //        view.backgroundColor = UIColor.white.withAlphaComponent(1)
        let headerLabel = UILabel(text: "Edit Details", font: .boldSystemFont(ofSize: 18), textColor: Theme.accentColor!, textAlignment: .center, numberOfLines: 0)
        formContainerStackView.addArrangedSubview(headerLabel)
        headerLabel.constrainHeight(50)
        if !(registerItems.isEmpty ){
            (0...(registerItems.count )-1).forEach { (i) in
                if registerItems[i] == "State" {
                    
                    let tf = FloatingLabelInput(placeholder: registerItems[i], cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .clear,height: heightCons)
                    tf.delegate = self
                    tf.accessibilityIdentifier = "State"
                    tf.text = userData[dataSort[i]] as? String
                    tf.borderWidth = 1.0
                    tf.borderColor = Theme.accentColor
                    tf.addStartLabel()
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
                else if registerItems[i] == "Country" {

                    let tf = FloatingLabelInput(placeholder: registerItems[i], cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .clear,height: heightCons)
                    tf.delegate = self
                    tf.accessibilityIdentifier = "Country"
                    tf.borderWidth = 1.0
                    tf.borderColor = Theme.accentColor
                    tf.text = userData[dataSort[i]] as? String
                    tf.addStartLabel()
                    countryPicker.delegate = self
                    tf.inputView = countryPicker
                    countryPicker.backgroundColor = UIColor.white
                    countryTextField = tf
                    formContainerStackView.addArrangedSubview(countryTextField)
                }
                else if registerItems[i] == "Mobile No" {
                    addMobileNumberTextField(index: i)
                }
                else if registerItems[i] == "Gender" {
                    
                    let tf = FloatingLabelInput(placeholder: registerItems[i], cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .clear,height: heightCons)
                    tf.delegate = self
                    genderPicker.delegate = self
                    tf.accessibilityIdentifier = "Gender"
                    tf.text = userData[dataSort[i]] as? String
                    tf.addStartLabel()
                    tf.inputView = genderPicker
                    tf.borderWidth = 1.0
                    tf.borderColor = Theme.accentColor
                    genderPicker.backgroundColor = UIColor.white
                    genderTextField = tf
                    formContainerStackView.addArrangedSubview(genderTextField)
                }
                else if registerItems[i] == "Date Of Birth" {
                    
                    let tf = FloatingLabelInput(placeholder: registerItems[i], cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .clear,height: heightCons)
                    tf.delegate = self
                    tf.accessibilityIdentifier = "dob"
                    tf.borderWidth = 1.0
                    tf.borderColor = Theme.accentColor
                    tf.text = userData[dataSort[i]] as? String
                    tf.addStartLabel()
                    tf.isEnabled = false
                    tf.alpha = 0.5
                    formContainerStackView.addArrangedSubview(tf)
                    
                }
                else if registerItems[i] == "Name" {
                    
                    let tf = FloatingLabelInput(placeholder: registerItems[i], cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .clear,height: heightCons)
                    tf.delegate = self
                    tf.accessibilityIdentifier = "name"
                    tf.borderWidth = 1.0
                    tf.borderColor = Theme.accentColor
                    tf.text = userData[dataSort[i]] as? String
                    tf.addStartLabel()
                    tf.isEnabled = false
                    tf.alpha = 0.5
                    formContainerStackView.addArrangedSubview(tf)
                    
                }
                    
                else{
                    let tf = FloatingLabelInput(placeholder: registerItems[i], cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .clear,height: heightCons)
                    if registerItems[i] == "Pincode" ||  registerItems[i] == "Mobile No"{
                        tf.keyboardType = .numberPad
                        tf.accessibilityIdentifier = registerItems[i]
                    }
                    else{
                        tf.accessibilityIdentifier = dataSort[i]
                    }
                    tf.text = userData[dataSort[i]] as? String
                    tf.borderWidth = 1.0
                    tf.borderColor = Theme.accentColor
                    tf.addStartLabel()
                    tf.addDoneButton(title: "DONE", target: self, selector: #selector(tapDone(sender:)))
                    formContainerStackView.addArrangedSubview(tf)
                    tf.delegate = self
                }
                
                
                
                
            }
            formContainerStackView.addArrangedSubview(saveButton)
            saveButton.constrainHeight(50)
            saveButton.cornerRadius = 10
            formContainerStackView.spacing = 25
        }
        
        //        signUpButton.constrainHeight(heightCons)
        createToolbar()
        
    }
    @objc func tapDone(sender: FloatingLabelInput) {
             view.endEditing(true)
    }
    @objc fileprivate func handleCancel() {
           dismiss(animated: true)
       }
    
    @objc fileprivate func handleRegister() {
        if validationDict.isEmpty {
            updateUserDetails()
        } else {
            showAlertView("Alert", message: "Please provide valid information.")
        }
    }
    func selectedCountryIsIndia() -> Bool {
          if let country = editDetails["patient_country"] as? String, country == "India" {
              return true
          }
          return false
      }
    
    func addMobileNumberTextField(index:Int) {
        let tf1 = FloatingLabelInput(placeholder: selectedCountryIsIndia() ? "+91" : "+971", cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .clear,height: 60)
        
        let tf2 = FloatingLabelInput(placeholder: "Mobile No", cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .clear, height: 60)
        tf1.accessibilityIdentifier = "Country Code"
        tf2.accessibilityIdentifier = "Mobile No"
        tf2.delegate = self
        tf1.isEnabled = false
        tf1.borderWidth = 1.0
        tf1.addStartLabel()
        tf2.addStartLabel()
        tf1.borderColor = Theme.accentColor
        tf2.borderWidth = 1.0
        tf2.borderColor = Theme.accentColor
        tf2.text = userData[dataSort[index]] as? String
        tf2.addDoneButton(title: "DONE", target: self, selector: #selector(tapDone(sender:)))
        let buttonsStackViewa = UIStackView(arrangedSubviews: [tf1, tf2])
        tf1.constrainWidth(70)
        tf2.constrainWidth(view.frame.width - 70)
        buttonsStackViewa.constrainHeight(heightCons)
        buttonsStackViewa.spacing = 12
        buttonsStackViewa.tag = 100
        formContainerStackView.addArrangedSubview(buttonsStackViewa)
    }
    
    func createToolbar()
    {
        toolBar = UIToolbar(frame: CGRect())
        toolBar.sizeToFit()
        
        //Customizations
      toolBar.barTintColor = Theme.accentColor
        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(DotOpenEditDetails.closePickerView))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        stateTextField.inputAccessoryView = toolBar
        genderTextField.inputAccessoryView = toolBar
        countryTextField.inputAccessoryView = toolBar
    }
    @objc func closePickerView()
        {
            
    //        getStates(country: countryTextField.text ?? "")
            view.endEditing(true)
        }
    
    func updateStateTextField(){
        
        let indexOfState = registerItems.firstIndex(of: "State") ?? 5 // 0
        if let view =  formContainerStackView.viewWithTag(101) {
            view.removeFromSuperview()
            formContainerStackView.removeArrangedSubview(view)
            statePicker.removeFromSuperview()
        }
        
        let tf = FloatingLabelInput(placeholder: RegistrationFields.State.rawValue, cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .clear,height: heightCons)
        tf.delegate = self
        tf.accessibilityIdentifier = "State"
        tf.borderWidth = 1.0
        tf.borderColor = Theme.accentColor
        tf.addStartLabel()
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
}
//MARK:API CAlls
extension DotOpenEditDetails{
    func updateUserDetails(){
//        if !validationDict.isEmpty || !(parameters1.count == (registerItems.count-1)){
//            showAlertView("Invalid Entries", message: "Please enter valid inputs")
//            return
//        }
      
        // Query item
        let queryItem = [ URLQueryItem(name: "keyName", value: "ValueName") ]
        for (key, value) in editDetails where (value as? String == kblankString || value as? [String] == [""]) {
           editDetails.removeValue(forKey: key)
        }
        guard let body = try? JSONSerialization.data(withJSONObject: editDetails) else { return }
       
        
        // Headers
        let headers = ["Content-Type":"application/json"]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.custom)
        let api: API = .patientsApi
        let endpoint: Endpoint = api.getPostAPIEndpointForAll(urlString: "\(api.rawValue)\(loginData.user_id ?? 17)", httpMethod: .put, queryItems: nil, headers: headers, body: body)
       
        client.callAPI(with: endpoint.request, modelParser: String.self) { [weak self] result in
            guard let self = self else { return }
            SVProgressHUD.dismiss()
            switch result {
                
            case .success(let model2Result):
                
                guard let model2Result = model2Result as? [String:AnyObject] else { return }
                print(model2Result)
                if model2Result.returnIntForKey(key: "status") != 400 {
                    self.delegate?.refreshTable(data: model2Result)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showAlertView(model2Result.returnStringForKey(key: "title"), message: model2Result.returnStringForKey(key: "detail"))
                }
                
            case .failure(let error):
                SVProgressHUD.dismiss()
                if case let APIError.errorAllResponse(description, message, _) = error {
                    self.showAlertView(message, message: description)
                }
                print("the error \(error)")
            }
        }
    }
}
extension DotOpenEditDetails:UITextFieldDelegate{

  
func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField.accessibilityIdentifier == "dob"{
        textField.openDatePicker(modeType: .date)
           }
    return true
 
}
    func textFieldDidEndEditing(_ textField: UITextField){
        var customField = textField as? FloatingLabelInput
        switch textField.accessibilityIdentifier  {
//        case "Name":
//            if let val = textField.text{
//                if val == kblankString{
//                  validationDict["patient_name"] = "yes"
//                    customField?.floatingLabelColor = .systemRed
//                    customField?.borderWidth = 1
//                    customField?.borderColor = .systemRed
//                }
//                else{
//                    validationDict.removeValue(forKey: "patient_name")
//                    customField?.floatingLabelColor = .darkGray
//                    customField?.borderWidth = 0
//                    editDetails["patient_name"] = val
//                }
//
//            }
//        case "Email-ID":
//            if let val = textField.text,validateEmail(email: val){
//                editDetails["patient_email"] = val
//                customField?.floatingLabelColor = .darkGray
//                customField?.borderWidth = 0
//                validationDict.removeValue(forKey: "email")
//            }
//            else{
//                customField?.floatingLabelColor = .systemRed
//                customField?.borderWidth = 1
//                customField?.borderColor = .systemRed
//                validationDict["email"] = "yes"
//            }
        case "Country":
            let previouslySelectedCountry:String? = editDetails["patient_country"] as? String
            if let val = textField.text{
                if !countryList.contains(val){
                    customField?.floatingLabelColor = .systemRed
                    customField?.borderWidth = 1
                    customField?.borderColor = .systemRed
                    validationDict["country"] = "yes"
                    
                }
                else{
                    customField?.floatingLabelColor = Theme.accentColor!
                    customField?.borderWidth = 1
                    editDetails["patient_country"] = val
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
                
                if previouslySelectedCountry != textField.text {
                    updateStateTextField()
                }
                
            }
//        case "Password":
//            if let val = textField.text,isValid(login: val){
//                editDetails["patient_password"] = val
//                validationDict.removeValue(forKey: "password")
//                customField?.floatingLabelColor = .darkGray
//                customField?.borderWidth = 0
//                if val == confirmPassword.text{
//                    (confirmPassword as? FloatingLabelInput)?.floatingLabelColor = .darkGray
//                    (confirmPassword as? FloatingLabelInput)?.borderWidth = 0
//                }
//                else{
//                    (confirmPassword as? FloatingLabelInput)?.floatingLabelColor = .systemRed
//                    (confirmPassword as? FloatingLabelInput)?.borderWidth = 1
//                    (confirmPassword as? FloatingLabelInput)?.borderColor = .systemRed
//
//
//                }
//            }
//            else{
//                customField?.floatingLabelColor = .systemRed
//                customField?.borderWidth = 1
//                customField?.borderColor = .systemRed
//                validationDict["password"] = "yes"
//            }
//        case "Confirm Password":
//            if let val = textField.text,isValid(login: val), editDetails["patient_password"] as? String == val{
//                customField?.floatingLabelColor = .darkGray
//                customField?.borderWidth = 0
//                validationDict.removeValue(forKey: "Confirm Password")
//            }
//            else{
//                customField?.floatingLabelColor = .systemRed
//                customField?.borderWidth = 1
//                customField?.borderColor = .systemRed
//                validationDict["Confirm Password"] = "yes"
//
//            }
        case "Pincode":
            if let val = textField.text,val.count == 6{
                if Int(val) != nil{
                    editDetails["patient_pincode"] = val
                    validationDict.removeValue(forKey: "pincode")
                    customField?.floatingLabelColor = Theme.accentColor!
                    customField?.borderWidth = 1
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
//        case "Address 2":
//            if let val = textField.text,val != kblankString{
//                     editDetails["patient_address2"] = val
//                    customField?.floatingLabelColor = .darkGray
//                    customField?.borderWidth = 0
//                    validationDict.removeValue(forKey: "address2")
//            }else{
//
//                validationDict["address2"] = "yes"
//                customField?.floatingLabelColor = .systemRed
//                customField?.borderWidth = 1
//                customField?.borderColor = .systemRed
//                }
                
            
//        case "Address 1":
//            if let val = textField.text,val != kblankString{
//                                editDetails["patient_address1"] = val
//                validationDict.removeValue(forKey: "address1")
//                               customField?.floatingLabelColor = .darkGray
//                               customField?.borderWidth = 0
//                       }else{
//
//                           validationDict["address1"] = "yes"
//                           customField?.floatingLabelColor = .systemRed
//                           customField?.borderWidth = 1
//                           customField?.borderColor = .systemRed
//                           }

        case "State":
            if let val = textField.text{
                if !states.contains(val){
                    customField?.floatingLabelColor = .systemRed
                    customField?.borderWidth = 1
                    customField?.borderColor = .systemRed
                    validationDict["state"] = "yes"
                }
                else{
                    customField?.floatingLabelColor = Theme.accentColor!
                    customField?.borderWidth = 1
                    editDetails["patient_state"] = val
                    validationDict.removeValue(forKey: "state")
                }
            }
//        case "City":
//            if let val = textField.text,val != kblankString{
//                     editDetails["patient_city"] = val
//                    customField?.floatingLabelColor = .darkGray
//                    customField?.borderWidth = 0
//                validationDict.removeValue(forKey: "city")
//            }else{
//                validationDict["city"] = "yes"
//                customField?.floatingLabelColor = .systemRed
//                customField?.borderWidth = 1
//                customField?.borderColor = .systemRed
//                }
//
        case "Gender":
            if let val = textField.text{
                if !genders.contains(val){
                    validationDict["gender"] = "yes"
                    customField?.floatingLabelColor = .systemRed
                    customField?.borderWidth = 1
                    customField?.borderColor = .systemRed
                }
                else{
                    editDetails["patient_gender"] = val
                        customField?.floatingLabelColor = Theme.accentColor!
                        customField?.borderWidth = 1
                    validationDict.removeValue(forKey: "gender")
                }
            }
//        case "Referal Code":
//            if let val = textField.text,val != kblankString{
//                                editDetails["patient_refcode"] = val
//                               customField?.floatingLabelColor = .darkGray
//                               customField?.borderWidth = 0
//                validationDict.removeValue(forKey: "ref")
//                       }else{
//
//                           validationDict["ref"] = "yes"
//                           customField?.floatingLabelColor = .systemRed
//                           customField?.borderWidth = 1
//                           customField?.borderColor = .systemRed
//                           }
        case "dob":
            if let val = textField.text{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                if let date = dateFormatter.date(from: val),Date() >= date{
                    editDetails["patient_dob"] = val
                    validationDict.removeValue(forKey: "dob")
                    customField?.floatingLabelColor = Theme.accentColor!
                    customField?.borderWidth = 1
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
                customField?.floatingLabelColor = Theme.accentColor!
                customField?.borderWidth = 1
                editDetails["patient_mobile"] = "+91-" + val
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
            if let val = textField.text{
                if val == kblankString && !optionalVals.contains(textField.accessibilityIdentifier!){
                customField?.floatingLabelColor = .systemRed
                customField?.borderWidth = 1
                customField?.borderColor = .systemRed
            }
            else{
                
                    customField?.floatingLabelColor = Theme.accentColor!
                customField?.borderWidth = 1
                     customField?.borderWidth = 1.0
                editDetails[textField.accessibilityIdentifier ?? ""] = val
            }
            }
        }
    }
}
extension DotOpenEditDetails:UIPickerViewDataSource, UIPickerViewDelegate{
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

