//
//  DotDetailsCellView.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 11/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class DotDetailsCellView: UITableViewCell {

    @IBOutlet weak var buttonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailText: UITextField!
    @IBOutlet weak var first: UILabel!
    var isExpand : Bool?
    var expandableRows = [Any]()
    var retainRows : [String:[Any]]?
    @IBAction func startEdit(_ sender: Any) {
        if self.detailText.isEnabled{
            self.detailText.borderStyle = .none
            self.detailText.isEnabled = false
        }
        else{
            self.detailText.borderStyle = .roundedRect
            self.detailText.isEnabled = true
        }
    }
        
    @IBOutlet weak var indicatorButton: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        setupView()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryView?.addSubview(UIImageView(image: #imageLiteral(resourceName: "settings")))
        // Configure the view for the selected state
    }
   
}
