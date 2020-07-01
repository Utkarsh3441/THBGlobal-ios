//
//  MultiDetailsTableViewCell.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 12/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class MultiDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var firstText: UITextField!
    @IBOutlet weak var first: UILabel!
     @IBOutlet weak var yesButton: UIButton!
     @IBOutlet weak var noButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        firstText.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func startEdit(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            if yesButton.imageView?.image?.imageAsset == UIImage(systemName: "checkmark.circle")?.imageAsset{
               
                
                self.yesButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                self.noButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
               
            }
            else if yesButton.imageView?.image?.imageAsset == UIImage(systemName: "checkmark.circle.fill")?.imageAsset{
                firstText.isHidden = true
                self.noButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                self.yesButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            }
        case 1:
            if noButton.imageView?.image?.imageAsset == UIImage(systemName: "checkmark.circle")?.imageAsset{
                self.firstText.borderStyle = .roundedRect
                
                self.noButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                self.yesButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            }
            else if noButton.imageView?.image?.imageAsset == UIImage(systemName: "checkmark.circle.fill")?.imageAsset{
                firstText.isHidden = false
                self.yesButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                self.noButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            }
        

        default:
            print("nithing")
        }
    }
}
