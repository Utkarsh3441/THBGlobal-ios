//
//  DotDoctorTableViewCell.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 18/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class DotDoctorTableViewCell: UITableViewCell {

    @IBOutlet weak var doctorImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //to have full length cell separator
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUp(rowIndex:Int,dataArray:[Any]){
        if let myMedicineDataArray = dataArray as? [MyMedicineModel]{
            self.doctorImageView.image = UIImage(named: "medImage")
            self.nameLabel.text = myMedicineDataArray[rowIndex].drug_name
            if let days =  myMedicineDataArray[rowIndex].days {
                self.specialityLabel.text = "\(days) Days"
            }
            self.hospitalNameLabel.text = myMedicineDataArray[rowIndex].dosage_instructions
            self.priceLabel.text = kblankString
            self.priceLabel.textColor = #colorLiteral(red: 0, green: 0.6795158386, blue: 0, alpha: 1)
            
        }
        if let doctorArray = dataArray as? [DoctorModel]{
            self.doctorImageView.image = UIImage(named: "DoctorImage")
            self.nameLabel.text = doctorArray[rowIndex].name
            self.specialityLabel.text = doctorArray[rowIndex].specialization
            self.hospitalNameLabel.text = doctorArray[rowIndex].city
            if let fees = doctorArray[rowIndex].fees {
                self.priceLabel.text = "$ \(fees)"
                self.priceLabel.isHidden = false

            }  else {
                self.priceLabel.isHidden = true
            }
            self.priceLabel.textColor = #colorLiteral(red: 0, green: 0.6795158386, blue: 0, alpha: 1)
        }
        if let facilityArray = dataArray as? [FacilityModel]{
            self.doctorImageView.image = UIImage(named: "hospitalImage")
            self.nameLabel.text = facilityArray[rowIndex].name
            self.specialityLabel.text = facilityArray[rowIndex].description
            self.hospitalNameLabel.text = facilityArray[rowIndex].city
//            if let fees = facilityArray[rowIndex].fees {
//                self.priceLabel.text = "$ (\(fees)"
//                self.priceLabel.textColor = #colorLiteral(red: 0, green: 0.6795158386, blue: 0, alpha: 1)
//                self.priceLabel.isHidden = true
//            }
//            else {
                self.priceLabel.isHidden = true
           // }
            
        }
        
    }

}
