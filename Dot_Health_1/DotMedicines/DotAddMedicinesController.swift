//
//  DotAddMedicinesController.swift
//  Dot_Health_1
//
//  Created by Utkarsh Agarwal on 8/29/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//



import Foundation
import LBTATools
import SVProgressHUD
import TinyConstraints
@objc protocol addMedicineTableDelegate: NSObjectProtocol{

    func refreshTable(data: [String:AnyObject])
}
class DotAddMedicinesController: LBTAFormController {
    var heightCons : CGFloat = 0.0
    let client = DotConnectionClient()
    weak var delegate:addMedicineTableDelegate?
    var addMedicineItems = [String]()
    var dataSort = ["drug_name","days","medication_type","dose_per_day","dosage_instructions","other_instruction"]
    
    
    var dataLabel = ["Medicine Name","Prescribed For (Days)","Prescribed","Dose per day","Instructions","Precautions (Optional)"]
    
    var optionalVals = ["other_instruction"]

    var editDetails = ["drug_name":"",
     "days":"",
     "medication_type":"",
     "dose_per_day":"",
     "dosage_instructions":"",
     "other_instruction":"" ] as [String : Any]
    
   var dropDownTextField = UITextField()
   var validationDict = [String:Any]()

    var userData = [String:AnyObject]()
    let saveButton = UIButton(title: "Save", titleColor: .white, font: .boldSystemFont(ofSize: 16), backgroundColor: Theme.gradientColorDark!, target: self, action: #selector(handleSaveButtonTapped))
       let cancelButton = UIButton(title: "", titleColor: .white, font: .boldSystemFont(ofSize: 16), backgroundColor: .green, target: self, action: nil)
    var dropDown = ["Off Platform","On Platform"]
    let genderPicker = UIPickerView()
    var toolBar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for value in dataLabel {
            addMedicineItems.append(value)
        }
//        for value in AddMedicineModel.allCases {
//            validationDict[value.rawValue] = "yes"
//        }

        
        heightCons = 40
        scrollView.alwaysBounceVertical = true
      //  view.backgroundColor = UIColor(hex: "#d8e5e2")
        view.backgroundColor = UIColor.white
        formContainerStackView.axis = .vertical
        formContainerStackView.spacing = 12
        for (k,v) in (userData){
            editDetails[k] = v
        }
        formContainerStackView.layoutMargins = .init(top: 25, left: 24, bottom: 30, right: 24)
        //        formContainerStackView.backgroundColor = .white
        //        view.backgroundColor = UIColor.white.withAlphaComponent(1)
        let headerLabel = UILabel(text: "Add Medication", font: .boldSystemFont(ofSize: 18), textColor: Theme.accentColor!, textAlignment: .center, numberOfLines: 0)
        formContainerStackView.addArrangedSubview(headerLabel)
        headerLabel.constrainHeight(50)
        if !(addMedicineItems.isEmpty ){
            (0...(addMedicineItems.count )-1).forEach { (i) in
              
                if addMedicineItems[i] == dataLabel[2] {
                    
                    let tf = FloatingLabelInput(placeholder: addMedicineItems[i], cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .clear,height: heightCons)
                    tf.delegate = self
                    genderPicker.delegate = self
                    tf.accessibilityIdentifier = AddMedicineModel.Prescribed.rawValue
                    tf.text = userData[dataSort[i]] as? String
                    tf.addStartLabel()
                    tf.inputView = genderPicker
                    tf.borderWidth = 1.0
                    tf.borderColor = Theme.accentColor
                    genderPicker.backgroundColor = UIColor.white
                    dropDownTextField = tf
                    formContainerStackView.addArrangedSubview(dropDownTextField)
                }
                    
                else{
                    let tf = FloatingLabelInput(placeholder: addMedicineItems[i], cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .clear,height: heightCons)
                    if addMedicineItems[i] == dataLabel[1] ||  addMedicineItems[i] == dataLabel[3] {
                        tf.keyboardType = .numberPad
                    }
                    else{
                    }
                    tf.accessibilityIdentifier = dataSort[i]
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
    
    @objc fileprivate func handleSaveButtonTapped() {
        if validationDict.isEmpty {
            addMedicineDetails()
        } else {
            showAlertView("Alert", message: "Please provide valid information.")
        }
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
        dropDownTextField.inputAccessoryView = toolBar
    }
    @objc func closePickerView()
        {
            
    //        getStates(country: countryTextField.text ?? "")
            view.endEditing(true)
        }
    
}
//MARK:API CAlls
extension DotAddMedicinesController{
    func addMedicineDetails(){
//        if validationDict.count > 1 || (validationDict.count == 1 && validationDict.first?.value != optionalVals.first) {
//            showAlertView("Invalid Entries", message: "Please enter  valid inputs")
//            return
//        }
      
        // Query item
        let queryItem = [ URLQueryItem(name: "keyName", value: "ValueName") ]
        for (key, value) in editDetails where (value as? String == kblankString || value as? [String] == [""]) {
           editDetails.removeValue(forKey: key)
        }
        
        if editDetails.count < 5 {
            return
        }
        
        guard let body = try? JSONSerialization.data(withJSONObject: editDetails) else { return }
       
        
        // Headers
        let headers = ["Content-Type":"application/json"]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.custom)
        let api: API = .patientsApi
        let endpoint: Endpoint = api.getPostAPIEndpointForAll(urlString: "\(api.rawValue)\(loginData.user_id ?? 17)/medications", httpMethod: .post, queryItems: nil, headers: headers, body: body)
       
        client.callAPI(with: endpoint.request, modelParser: String.self) { [weak self] result in
            guard let self = self else { return }
            SVProgressHUD.dismiss()
            switch result {
                
            case .success(let model2Result):
                
                guard let model2Result = model2Result as? [String:AnyObject] else { return }
                print(model2Result)
                if model2Result.returnStringForKey(key: "type") == "Success" {
                    do {
                        let alert = UIAlertController(title: "Success", message: model2Result.returnStringForKey(key: "message"), preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (_) in
                            self.delegate?.refreshTable(data: model2Result)
                            self.dismiss(animated: true, completion: nil)
                            
                        }))
                        self.present(alert, animated: true, completion:nil)
                    }
                } else {
                    if  model2Result.returnStringForKey(key: "title").count > 0, model2Result.returnStringForKey(key: "detail").count > 0 {
                        
                        self.showAlertView(model2Result.returnStringForKey(key: "title"), message:model2Result.returnStringForKey(key: "detail"))

                        
                    } else {
                    self.showAlertView("Alert", message:"Something bad happened.")
                    }
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
extension DotAddMedicinesController:UITextFieldDelegate{

  
func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField.accessibilityIdentifier == "dob"{
        textField.openDatePicker(modeType: .date)
           }
    return true
 
}
    
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // Handle backspace/delete
        guard !string.isEmpty else {

            // Backspace detected, allow text change, no need to process the text any further
            return true
        }

        // Input Validation
        // Prevent invalid character input, if keyboard is numberpad
        if textField.keyboardType == .numberPad {

            // Check for invalid input characters
            if CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) {
                
                let maxValue = textField.accessibilityIdentifier == AddMedicineModel.prescribedForDays.rawValue ? 30 : 10
                // Need to convert the NSRange to a Swift-appropriate type
                if let text = textField.text, let range = Range(range, in: text) {

                    let proposedText = text.replacingCharacters(in: range, with: string)

                    // Check proposed text length does not exceed max character count
                    guard proposedText.count <= 2 else {
                        return false
                    }
                    if let finalValue = Int(proposedText) {
                        if finalValue > maxValue {
                            return false
                        }
                    }
                }
                return true
            } else {
                return false
            }
        }

        // Length Processing

        // Allow text change
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField){
        var customField = textField as? FloatingLabelInput
        switch textField.accessibilityIdentifier  {

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
   
        case AddMedicineModel.Prescribed.rawValue:
            if let val = textField.text{
                if !dropDown.contains(val){
                    validationDict[AddMedicineModel.Prescribed.rawValue] = "yes"
                    customField?.floatingLabelColor = .systemRed
                    customField?.borderWidth = 1
                    customField?.borderColor = .systemRed
                }
                else{
                    editDetails["medication_type"] = val
                        customField?.floatingLabelColor = Theme.accentColor!
                        customField?.borderWidth = 1
                    validationDict.removeValue(forKey: AddMedicineModel.Prescribed.rawValue)
                }
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
                    if textField.accessibilityIdentifier ==  AddMedicineModel.dosePerDay.rawValue ||  textField.accessibilityIdentifier ==  AddMedicineModel.prescribedForDays.rawValue {
                        editDetails[textField.accessibilityIdentifier ?? ""] = Int(val)
                        
                    } else {
                        editDetails[textField.accessibilityIdentifier ?? ""] = val

                    }
                    
                    
            }
            }
        }
    }
}
extension DotAddMedicinesController:UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return dropDown.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?  {
        return dropDown[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dropDownTextField.text = dropDown[row]
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
        
        label.text = dropDown[row]
        return label
    }
    
    
}


