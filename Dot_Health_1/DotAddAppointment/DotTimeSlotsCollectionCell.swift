//
//  DotTimeSlotsCollectionCell.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 20/07/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit
import Kingfisher
import TinyConstraints
import Foundation
protocol SelfConfiguringCells {
    static var reuseIdentifier: String { get }
}
class DotTimeSlotsCollectionCell: UICollectionViewCell, SelfConfiguringCells  {
    static var reuseIdentifier: String = "cardCell"
    var isSelect : Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
//    lazy var activityIndicatorView: UIActivityIndicatorView = {
//        let aiv = UIActivityIndicatorView()
//        aiv.startAnimating()
//        return aiv
//    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    func setupView(){
        //configure Cell
        backgroundColor = Theme.backgroundColor
        layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        layer.borderWidth = 1
        
        layer.cornerRadius = 5
        self.layer.shadowColor = #colorLiteral(red: 0.2748524845, green: 0.4150594473, blue: 0.4139105678, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.5
        clipsToBounds = true
        self.layer.masksToBounds = false
        //Setup cell
       
        addSubview(nameLabel)
        nameLabel.edgesToSuperview()
      
        
    }
    func changeColor(state:String){
        switch state{
        case "booked" :
            backgroundColor = .white
              nameLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
              layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        case "completed" :
            backgroundColor = Theme.gradientColorDark
            nameLabel.textColor = .white
            layer.borderColor = Theme.gradientColorDark?.cgColor
        case "available":
            backgroundColor = .white
            nameLabel.textColor = Theme.gradientColorDark
            layer.borderColor = Theme.gradientColorDark?.cgColor
        default:
            backgroundColor = #colorLiteral(red: 0.6969275475, green: 0.9807969928, blue: 0.9244244695, alpha: 1)
            nameLabel.textColor = Theme.gradientColorDark
            layer.borderColor = Theme.gradientColorDark?.cgColor
        }
      
    }
}

