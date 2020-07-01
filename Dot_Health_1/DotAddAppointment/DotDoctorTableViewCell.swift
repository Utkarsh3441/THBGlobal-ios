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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUp(rowIndex:Int){
        self.doctorImageView.image = UIImage(named: "DoctorImage")
        self.nameLabel.text = MyData.doctorModelArray[rowIndex].name
        self.specialityLabel.text = MyData.doctorModelArray[rowIndex].speciality
        self.hospitalNameLabel.text = MyData.doctorModelArray[rowIndex].hospitalName
        self.priceLabel.text = MyData.doctorModelArray[rowIndex].price
        self.priceLabel.textColor = #colorLiteral(red: 0, green: 0.6795158386, blue: 0, alpha: 1)
    }

}
