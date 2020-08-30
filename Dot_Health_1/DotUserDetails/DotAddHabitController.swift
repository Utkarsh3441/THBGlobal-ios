//
//  DotAddHabitController.swift
//  Dot_Health_1
//
//  Created by Utkarsh Agarwal on 8/30/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//


import Foundation
import LBTATools
import SVProgressHUD
import TinyConstraints
@objc protocol addHabitTableDelegate: NSObjectProtocol{

    func refreshHabitsTable(data: [String:AnyObject])
}
class DotAddHabitController: LBTAFormController {
    var heightCons : CGFloat = 0.0
    let client = DotConnectionClient()
    weak var delegate:addHabitTableDelegate?
    var addHabitItems = [String]()
    var dataSort = ["habit_name","habit_frequency","habit_frequency_unit"]
    var selectedFrequencyIndex: Int?
    var habitIsActive = true
    var selectedHabitID:Int?
    var isEditSelected:Bool = false
    var habitData:DotAddHabitModel?
    
    
    var dataLabel = ["Habit Name","Frequency","Frequency Unit","Status"]
    
    var editDetails = ["habit_name":"",
     "habit_frequency":"",
     "habit_frequency_unit":"",
     ] as [String : Any]
    
   var dropDownTextField = UITextField()
   var validationDict = [String:Any]()

    let saveButton = UIButton(title: "Save", titleColor: .white, font: .boldSystemFont(ofSize: 16), backgroundColor: Theme.gradientColorDark!, target: self, action: #selector(handleSaveButtonTapped))
       let cancelButton = UIButton(title: "", titleColor: .white, font: .boldSystemFont(ofSize: 16), backgroundColor: .green, target: self, action: nil)

    var toolBar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEditSelected {
            fetchHabitDetails()
        } else {
            loadDataInView()
        }
        
    
        
    }
    
    func loadDataInView() {
        for value in dataLabel {
                  addHabitItems.append(value)
              }
              
              heightCons = 40
              scrollView.alwaysBounceVertical = true
            //  view.backgroundColor = UIColor(hex: "#d8e5e2")
              view.backgroundColor = UIColor.white
              formContainerStackView.axis = .vertical
              formContainerStackView.spacing = 12
             
              formContainerStackView.layoutMargins = .init(top: 25, left: 24, bottom: 30, right: 24)
              //        formContainerStackView.backgroundColor = .white
              //        view.backgroundColor = UIColor.white.withAlphaComponent(1)
              let labelHeader = isEditSelected == true ? "Edit Habit" : "Add Habit"
              
              let headerLabel = UILabel(text: labelHeader, font: .boldSystemFont(ofSize: 18), textColor: Theme.accentColor!, textAlignment: .center, numberOfLines: 0)
              formContainerStackView.addArrangedSubview(headerLabel)
              headerLabel.constrainHeight(50)
              if !(addHabitItems.isEmpty ){
                  (0...(addHabitItems.count )-1).forEach { (i) in
                    
                      if addHabitItems[i] == dataLabel[2] {
                          addCheckBoxTextField(isAlreadyAdded: false)
                      } else if addHabitItems[i] == dataLabel[3]{
                        addActiveInactiveTextField(isAlreadyAdded: false)
                      }
                          
                      else{
                          let tf = FloatingLabelInput(placeholder: addHabitItems[i], cornerRadius: 5, keyboardType: .emailAddress, backgroundColor: .clear,height: heightCons)
                          if addHabitItems[i] == dataLabel[1]  {
                              tf.keyboardType = .numberPad
                          }
                          else{
                          }
                        if dataSort[i] == "habit_frequency" {
                            if let frequency = habitData?.frequency {
                                tf.text =  String(frequency)
                            }
                        } else if dataSort[i] == "habit_name" {
                            if let name = habitData?.habitName {
                                tf.text =  name
                            }
                        }
                                                
                          tf.accessibilityIdentifier = dataSort[i]
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
    
    func setSelectedFrequencyIndex() {
        
        if isEditSelected == true {
            if let frequency =  habitData?.frequencyUnit {
                
                switch frequency {
                case "Per Day":
                    selectedFrequencyIndex = 0
                case "Per Week":
                    selectedFrequencyIndex = 1
                case "Per Month":
                    selectedFrequencyIndex = 2
                default:
                    return
                }
            }
        }
    }
    
    func addCheckBoxTextField(isAlreadyAdded:Bool) {
        
        if isAlreadyAdded == true {
            if let view =  formContainerStackView.viewWithTag(101) {
                view.removeFromSuperview()
                formContainerStackView.removeArrangedSubview(view)
            }
        }
   
        let checkBoxButton1 = UIButton(image: UIImage(named: "ic_deselect_circle.png")!, target: self, action: #selector(checkMarkBtnTapped))
        checkBoxButton1.backgroundColor = UIColor.clear
        checkBoxButton1.tag = 0
        
        let checkBoxButton2 = UIButton(image: UIImage(named: "ic_deselect_circle.png")!, target: self, action: #selector(checkMarkBtnTapped))
        checkBoxButton2.tag = 1
        
        let checkBoxButton3 = UIButton(image: UIImage(named: "ic_deselect_circle.png")!, target: self, action: #selector(checkMarkBtnTapped))
        checkBoxButton3.tag = 2
        
        if selectedFrequencyIndex == checkBoxButton1.tag {
            checkBoxButton1.setImage(UIImage(named: "ic_selection_circle.png"), for: .normal)
        } else if selectedFrequencyIndex == checkBoxButton2.tag {
            checkBoxButton2.setImage(UIImage(named: "ic_selection_circle.png"), for: .normal)
        } else if selectedFrequencyIndex == checkBoxButton3.tag {
            checkBoxButton3.setImage(UIImage(named: "ic_selection_circle.png"), for: .normal)
        }

        
        let label1 = UILabel(text: "Daily", font: UIFont(name: "Rockwell-Regular", size: 14), textColor: .black, textAlignment: .left, numberOfLines: 0)
        
        let label2 = UILabel(text: "Weekly", font: UIFont(name: "Rockwell-Regular", size: 14), textColor: .black, textAlignment: .left, numberOfLines: 0)

        let label3 = UILabel(text: "Monthly", font: UIFont(name: "Rockwell-Regular", size: 14), textColor: .black, textAlignment: .left, numberOfLines: 0)

              
        let buttonsStackViewa = UIStackView(arrangedSubviews: [checkBoxButton1,label1,checkBoxButton2, label2, checkBoxButton3, label3])
        checkBoxButton1.constrainWidth(32)
        checkBoxButton2.constrainWidth(32)
        checkBoxButton3.constrainWidth(32)
        label1.constrainWidth(50)
        label2.constrainWidth(60)
        label3.constrainWidth(60)
        
        buttonsStackViewa.constrainHeight(heightCons)
        buttonsStackViewa.spacing = 8
       // buttonsStackViewa.tag = 101
        
        let headerLabel = UILabel(text: "Frequency Unit", font: UIFont(name: "Rockwell-Regular", size: 14), textColor:Theme.accentColor!, textAlignment: .left, numberOfLines: 0)

        
        let finalStackView  = UIStackView(arrangedSubviews: [headerLabel,buttonsStackViewa])
        finalStackView.axis = .vertical
        finalStackView.constrainHeight(70.0)
        finalStackView.spacing = 8
        finalStackView.tag = 101
        
        
        if isAlreadyAdded == true {
            formContainerStackView.insertArrangedSubview(finalStackView, at: 3)
        } else {
            formContainerStackView.addArrangedSubview(finalStackView)
        }
    }
    
    func addActiveInactiveTextField(isAlreadyAdded:Bool) {
          
          if isAlreadyAdded == true {
              if let view =  formContainerStackView.viewWithTag(102) {
                  view.removeFromSuperview()
                  formContainerStackView.removeArrangedSubview(view)
              }
          }
     
          let checkBoxButton1 = UIButton(image: UIImage(named: "ic_deselect_circle.png")!, target: self, action: #selector(statusBtnTapped))
          checkBoxButton1.backgroundColor = UIColor.clear
          checkBoxButton1.tag = 10
          
          let checkBoxButton2 = UIButton(image: UIImage(named: "ic_deselect_circle.png")!, target: self, action: #selector(statusBtnTapped))
          checkBoxButton2.tag = 11
          
          
        if habitIsActive == true {
            checkBoxButton1.setImage(UIImage(named: "ic_selection_circle.png"), for: .normal)
        } else {
            checkBoxButton2.setImage(UIImage(named: "ic_selection_circle.png"), for: .normal)
        }

          
          let label1 = UILabel(text: "Yes", font: UIFont(name: "Rockwell-Regular", size: 14), textColor: .black, textAlignment: .left, numberOfLines: 0)
          
          let label2 = UILabel(text: "No", font: UIFont(name: "Rockwell-Regular", size: 14), textColor: .black, textAlignment: .left, numberOfLines: 0)


                
          let buttonsStackViewa = UIStackView(arrangedSubviews: [checkBoxButton1,label1,checkBoxButton2, label2])
          checkBoxButton1.constrainWidth(32)
          checkBoxButton2.constrainWidth(32)
          label1.constrainWidth(50)
          label2.constrainWidth(60)
          
          buttonsStackViewa.constrainHeight(heightCons)
          buttonsStackViewa.spacing = 8
          
          let headerLabel = UILabel(text: "Status", font: UIFont(name: "Rockwell-Regular", size: 14), textColor:Theme.accentColor!, textAlignment: .left, numberOfLines: 0)

          
          let finalStackView  = UIStackView(arrangedSubviews: [headerLabel,buttonsStackViewa])
          finalStackView.axis = .vertical
          finalStackView.constrainHeight(70.0)
          finalStackView.spacing = 8
          finalStackView.tag = 102
          
          
          if isAlreadyAdded == true {
              formContainerStackView.insertArrangedSubview(finalStackView, at: 4)
          } else {
              formContainerStackView.addArrangedSubview(finalStackView)
          }
      }
    
    @objc func statusBtnTapped(sender: UIButton) {
        habitIsActive = !habitIsActive
        addActiveInactiveTextField(isAlreadyAdded: true)
    }
    
    @objc func checkMarkBtnTapped(sender: UIButton) {
        selectedFrequencyIndex = sender.tag
        addCheckBoxTextField(isAlreadyAdded: true)
     }
    
    
    @objc func tapDone(sender: FloatingLabelInput) {
             view.endEditing(true)
    }
    @objc fileprivate func handleCancel() {
           dismiss(animated: true)
       }
    
    @objc fileprivate func handleSaveButtonTapped() {
        if validationDict.isEmpty {
            isEditSelected == true ? editHabitDetails() : addHabitDetails()
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
    
    func returnSelctedFrequencyParamName()->String {
        if selectedFrequencyIndex == 0 {
            return "Per Day"
        } else if selectedFrequencyIndex == 1 {
            return "Per Week"
        } else if selectedFrequencyIndex == 2 {
            return "Per Month"
        }
        return ""
    }
    func returnSelctedFrequencyIndex()->String {
        if selectedFrequencyIndex == 0 {
            return "Per Day"
        } else if selectedFrequencyIndex == 1 {
            return "Per Week"
        } else if selectedFrequencyIndex == 2 {
            return "Per Month"
        }
        return ""
    }
    
}
//MARK:API CAlls
extension DotAddHabitController {
    func fetchHabitDetails(){
        
        guard let habitId  = selectedHabitID else {
            return()
        }
    // Headers
        let headers = ["Content-Type":"application/json"]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.custom)
        let api: API = .patientsApi
        let endpoint: Endpoint = api.getPostAPIEndpointForAll(urlString: "\(api.rawValue)\(loginData.user_id ?? 17)/habits/\(habitId)", httpMethod: .get, queryItems: nil, headers: headers, body: nil)
       
        client.callAPI(with: endpoint.request, modelParser: String.self) { [weak self] result in
            guard let self = self else { return }
            SVProgressHUD.dismiss()
            switch result {
                
            case .success(let model2Result):
                
                if let model = model2Result as? Dictionary<String,Any> {
                    self.habitData =   DotAddHabitModel.init(dict: model)
                }
                self.computeEditDetails()
                self.setSelectedFrequencyIndex()
                self.loadDataInView()
                
            case .failure(let error):
                SVProgressHUD.dismiss()
                if case let APIError.errorAllResponse(description, message, _) = error {
                    self.showAlertView(message, message: description)
                }
                print("the error \(error)")
            }
        }
    }
    
    func computeEditDetails() {
        editDetails["habit_name"] = returnSelctedFrequencyParamName()
        editDetails["habit_frequency_unit"] = returnSelctedFrequencyParamName()
        if let frequency = habitData?.frequency {
            editDetails["habit_frequency"] =  frequency
        }
        if let name = habitData?.habitName {
            editDetails["habit_name"] =  name
        }
        
    }
    
    func editHabitDetails() {
        
        guard let selectedHabitID = selectedHabitID else {
            return
        }
        
        if validationDict.count > 1 {
            showAlertView("Invalid Entries", message: "Please enter  valid inputs")
            return
        }
        
        if returnSelctedFrequencyParamName().count > 0 {
            editDetails["habit_frequency_unit"] = returnSelctedFrequencyParamName()
        }
        
        
        // Query item
        for (key, value) in editDetails where (value as? String == kblankString || value as? [String] == [""]) {
            editDetails.removeValue(forKey: key)
        }
        
        if editDetails.count < 3 {
            showAlertView("Invalid Entries", message: "Please enter valid inputs")
            return
        }
        
        guard let body = try? JSONSerialization.data(withJSONObject: editDetails) else { return }
        
        // Headers
        let headers = ["Content-Type":"application/json"]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.custom)
        let api: API = .patientsApi
        let endpoint: Endpoint = api.getPostAPIEndpointForAll(urlString: "\(api.rawValue)\(loginData.user_id ?? 17)/habits/\(selectedHabitID)", httpMethod: .put, queryItems: nil, headers: headers, body: body)
        
        client.callAPI(with: endpoint.request, modelParser: String.self) { [weak self] result in
            guard let self = self else { return }
            SVProgressHUD.dismiss()
            switch result {
                
            case .success(let model2Result):
                
                guard let model2Result = model2Result as? [String:AnyObject] else { return }
                print(model2Result)
                if model2Result.returnIntForKey(key: "status") != 400 {
                    self.delegate?.refreshHabitsTable(data: model2Result)
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
    
    
    func addHabitDetails(){
        if validationDict.count > 1 {
            showAlertView("Invalid Entries", message: "Please enter  valid inputs")
            return
        }
        
        if returnSelctedFrequencyParamName().count > 0 {
            editDetails["habit_frequency_unit"] = returnSelctedFrequencyParamName()
        }
    
        
        // Query item
        for (key, value) in editDetails where (value as? String == kblankString || value as? [String] == [""]) {
           editDetails.removeValue(forKey: key)
        }
        
        if editDetails.count < 3 {
            showAlertView("Invalid Entries", message: "Please enter valid inputs")
            return
        }
        
        guard let body = try? JSONSerialization.data(withJSONObject: editDetails) else { return }
        
        // Headers
        let headers = ["Content-Type":"application/json"]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.custom)
        let api: API = .patientsApi
        let endpoint: Endpoint = api.getPostAPIEndpointForAll(urlString: "\(api.rawValue)\(loginData.user_id ?? 17)/habits", httpMethod: .post, queryItems: nil, headers: headers, body: body)
       
        client.callAPI(with: endpoint.request, modelParser: String.self) { [weak self] result in
            guard let self = self else { return }
            SVProgressHUD.dismiss()
            switch result {
                
            case .success(let model2Result):
                
                guard let model2Result = model2Result as? [String:AnyObject] else { return }
                          print(model2Result)
                          if model2Result.returnIntForKey(key: "status") != 400 {
                              self.delegate?.refreshHabitsTable(data: model2Result)
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
extension DotAddHabitController:UITextFieldDelegate {

  
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
                
                let maxValue = 1000
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
        if let val = textField.text{
            if val == kblankString {
                customField?.floatingLabelColor = .systemRed
                customField?.borderWidth = 1
                customField?.borderColor = .systemRed
            }
            else{
                
                customField?.floatingLabelColor = Theme.accentColor!
                customField?.borderWidth = 1
                customField?.borderWidth = 1.0
                if textField.accessibilityIdentifier ==  AddHabitModel.habitFrequency.rawValue  {
                    editDetails[textField.accessibilityIdentifier ?? ""] = Int(val)
                    
                } else {
                    editDetails[textField.accessibilityIdentifier ?? ""] = val
                }
            }
        }
    }
}

enum AddHabitModel: String, CaseIterable {
    case habitName = "habit_name"
    case habitFrequency = "habit_frequency"
    case habitFrequencyUnit = "habit_frequency_unit"
}




