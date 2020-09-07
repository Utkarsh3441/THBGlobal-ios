//
//  DotAddGraphDataViewController.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 13/08/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class DotAddGraphDataViewController: UIViewController {
    @IBOutlet weak var vitalNameHeaderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var yAxixDataTextField: UITextField!
    var date:String?
    var time:String?
    var vitalHeader:String?
    var callback : (([String:String])->())?
    @IBOutlet weak var yAxixDataTextfield2: UITextField!
    
    @IBOutlet weak var yAxixLabel1: UILabel!
    
    @IBOutlet weak var yAxixLabel2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var myMutableStringTitle = NSMutableAttributedString()
          let Name  = "Enter Title" // PlaceHolderText

        myMutableStringTitle = NSMutableAttributedString(string:Name, attributes: [NSAttributedString.Key.font:UIFont(name: Theme.mainFontName, size: 17.0)!]) // Font
        myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.tintcolor ?? UIColor.white, range:NSRange(location:0,length:Name.count))    // Color
          yAxixDataTextField.attributedPlaceholder = myMutableStringTitle
        
        vitalNameHeaderLabel.text = vitalHeader
        dateLabel.text = date
        timelabel.text = time
        switch vitalHeader {
        case "Add Blood Pressure":
            self.yAxixDataTextField.placeholder = "mmHg"
            self.yAxixDataTextfield2.placeholder = "mmHg"
            self.showFields()
        case "Add Temperature":
            self.yAxixLabel1.text = vitalHeader
            self.yAxixDataTextField.placeholder = "celsius"
            self.hideFields()
        case "Add Height":
            self.yAxixLabel1.text = vitalHeader
            self.yAxixDataTextField.placeholder = "cm"
            self.hideFields()
        case "Add Weight":
            self.yAxixLabel1.text = vitalHeader
            self.yAxixDataTextField.placeholder = "kg"
            self.hideFields()
        case "Add Pulse":
            self.yAxixLabel1.text = vitalHeader
            self.yAxixDataTextField.placeholder = "BPM"
            self.hideFields()
        case "Add Respiration Rate":
            self.yAxixLabel1.text = vitalHeader
            self.yAxixDataTextField.placeholder = "BPM"
            self.hideFields()
        case "Add Oxygen Saturation":
            self.yAxixLabel1.text = vitalHeader
            self.yAxixDataTextField.placeholder = "percent"
            self.hideFields()
        case "Add Calories Burned":
            self.yAxixLabel1.text = vitalHeader
            self.yAxixDataTextField.placeholder = "kcal"
            self.hideFields()
        case "Add Blood Sugar":
            self.yAxixLabel1.text = vitalHeader
            self.yAxixDataTextField.placeholder = "mmol/L"
            self.hideFields()
        default:
            print("Wrong Vital selected")
        }
    }
    func hideFields(){
         self.yAxixLabel2.isHidden = true
         self.yAxixDataTextfield2.isHidden = true
    }
    func showFields(){
        self.yAxixLabel1.isHidden = false
        self.yAxixLabel2.isHidden = false
        self.yAxixDataTextField.isHidden = false
        self.yAxixDataTextfield2.isHidden = false
        
    }
    @IBAction func showGraphAction(_ sender: Any) {
        
        guard let firstTextCount = yAxixDataTextField.text, firstTextCount.count > 0 else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        
        var addedValue = firstTextCount
        let firstTextField = yAxixDataTextField.text?.count ?? 0
        
        if vitalHeader == "Add Blood Pressure" {
            let secondTextField = yAxixDataTextfield2.text?.count ?? 0
            
            if (firstTextField > 0 && secondTextField == 0) ||  (firstTextField == 0 && secondTextField > 0) {
                showAlertView("Please provide both required values", message: kblankString)
                return
            }
            if let secondValue = yAxixDataTextfield2.text {
                addedValue = addedValue + "," + secondValue
            }
        }
        
        callback?(["date":dateLabel.text ?? "", "time": timelabel.text ?? "", "vitalValue":addedValue, "unit": yAxixDataTextField.placeholder ?? ""])
        
        dismiss(animated: true, completion: nil)
    }
}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

