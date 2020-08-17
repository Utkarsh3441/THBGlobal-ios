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
        vitalNameHeaderLabel.text = vitalHeader
        dateLabel.text = date
        timelabel.text = time
        switch vitalHeader {
        case "Blood Pressure":
            self.showFields()
        case "Temperature":
            self.yAxixLabel1.text = vitalHeader
            self.yAxixDataTextField.placeholder = "celsius"
            self.hideFields()
        case "Height":
            self.yAxixLabel1.text = vitalHeader
            self.yAxixDataTextField.placeholder = "cm"
            self.hideFields()
        case "Weight":
            self.yAxixLabel1.text = vitalHeader
            self.yAxixDataTextField.placeholder = "kg"
            self.hideFields()
        case "Pulse":
            self.yAxixLabel1.text = vitalHeader
            self.yAxixDataTextField.placeholder = "BPM"
            self.hideFields()
        case "Respiration Rate":
            self.yAxixLabel1.text = vitalHeader
            self.yAxixDataTextField.placeholder = "BPM"
            self.hideFields()
        case "Oxygen Saturation":
            self.yAxixLabel1.text = vitalHeader
            self.yAxixDataTextField.placeholder = "percent"
            self.hideFields()
        case "Calories Burned":
            self.yAxixLabel1.text = vitalHeader
            self.yAxixDataTextField.placeholder = "kcal"
            self.hideFields()
        case "Blood Sugar":
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
        callback?(["date":dateLabel.text ?? "", "time": timelabel.text ?? "", "vitalValue":yAxixDataTextField.text ?? ""])
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
