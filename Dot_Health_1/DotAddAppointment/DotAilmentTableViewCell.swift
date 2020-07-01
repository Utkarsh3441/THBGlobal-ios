//
//  DotAilmentTableViewCell.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 25/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class DotAilmentTableViewCell: UITableViewCell {

    @IBOutlet weak var cellBGView: UIView!
    @IBOutlet weak var ailmentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if(selected){
            self.backgroundColor = .white
            self.ailmentLabel.textColor = .white
            self.cellBGView.backgroundColor = #colorLiteral(red: 0.1665293276, green: 0.5254830718, blue: 0.7482460141, alpha: 1)
            self.cellBGView.layer.shadowOpacity = 1
            self.cellBGView.layer.shadowOffset = CGSize.zero
            self.cellBGView.layer.shadowColor = UIColor.darkGray.cgColor
            self.cellBGView.layer.cornerRadius = 10
        }
       

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //set the values for top,left,bottom,right margins
        let margins = UIEdgeInsets(top: 100, left: 0, bottom: 100, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
    func setUp(rowValue:String){
        self.ailmentLabel.text = rowValue
        
    }

}
