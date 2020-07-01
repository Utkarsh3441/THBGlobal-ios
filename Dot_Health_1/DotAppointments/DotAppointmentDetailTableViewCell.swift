//
//  DotAppointmentDetailTableViewCell.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 16/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class DotAppointmentDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var detailTitleLabel: UILabel!
    
    @IBOutlet weak var detailValueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setup(appointmentModel: DotAppointmentModel) {
        self.detailTitleLabel.text = "Status"
        self.detailValueLabel.text = "Completed"
    }

}
