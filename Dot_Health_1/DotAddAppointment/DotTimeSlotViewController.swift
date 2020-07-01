//
//  DotTimeSlotViewController.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 27/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class DotTimeSlotViewController: UIViewController {

    @IBOutlet weak var doctorDetailView: UIView!
    @IBOutlet weak var doctorImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var morningButton: OptionButton!
   
    @IBOutlet weak var dateTextField: DotTextFieldUtility!
    @IBOutlet weak var eveningButton: OptionButton!
    @IBOutlet weak var afternoonButton: UIButton!
    @IBOutlet weak var slot4Button: OptionButton!
    @IBOutlet weak var slot3Button: OptionButton!
   
    @IBOutlet weak var slot2Button: UIButton!
    @IBOutlet weak var slot1Button: OptionButton!
    var selectedDocImage = UIImage()
    var selectedName = String()
    var selectedSpec = String()
    var selectedHosPitalName = String()
    var selectedPrice = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select a time slot"
        self.afternoonButton.createOptionButton()
        self.morningButton.createOptionButton()
         self.eveningButton.createOptionButton()
         self.slot1Button.createOptionButton()
         self.slot2Button.createOptionButton()
         self.slot3Button.createOptionButton()
         self.slot4Button.createOptionButton()
        self.dateTextField.delegate = self
        self.dateTextField.text = UtilityFunctions.getTodayDate()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setUpDoctorDetail(rowIndex: Int){
        self.doctorImageView.image = UIImage(named: "DoctorImage")
        self.nameLabel.text = MyData.doctorModelArray[rowIndex].name
        self.specialityLabel.text = MyData.doctorModelArray[rowIndex].speciality
        self.hospitalNameLabel.text = MyData.doctorModelArray[rowIndex].hospitalName
        self.priceLabel.text = MyData.doctorModelArray[rowIndex].price
        self.priceLabel.textColor = #colorLiteral(red: 0, green: 0.6795158386, blue: 0, alpha: 1)
    }
 
    @IBAction func optionButtonSelected(_ sender: UIButton) {
       sender.createSelectedOptionButton()
    
    }
    @objc func cancelButtonAcction(){
           dateTextField.resignFirstResponder()
         //  endDateTextField.resignFirstResponder()
       }
    
    
}
extension DotTimeSlotViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        textField.openDatePicker()
       
      // showPopup(calenderPopover, sourceView: textField)
    }
}
