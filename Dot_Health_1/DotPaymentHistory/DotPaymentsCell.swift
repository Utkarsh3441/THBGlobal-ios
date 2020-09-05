//
//  DotPaymentsCell.swift
//  tinder_messages_screen
//
//  Created by Animesh Mohanty on 05/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import LBTATools

class DotPaymentsCell: LBTAListCell<DotPaymentsModel> {
    
    let imageView = UIView(backgroundColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
     let l1 = UILabel(text: "13", font: .boldSystemFont(ofSize: 18), textColor: Theme.gradientColorDark!, textAlignment: .center, numberOfLines: 0)
    let l2 = UILabel(text: "Apr 2020", font: .boldSystemFont(ofSize: 11), textColor: Theme.gradientColorDark!)
     let l3 = UILabel(text: "ID: ", font: .boldSystemFont(ofSize: 13), textColor: .darkGray)
    let nameLabel = UILabel(text: "User name", font: .boldSystemFont(ofSize: 16))
    let messageLabel = UILabel(text: "Hey girl, what's up there? Let's go out and have a drink tonight?", font: .boldSystemFont(ofSize: 14), textColor: .gray, numberOfLines: 2)
    
    override var item: DotPaymentsModel! {
        didSet {
            nameLabel.text = "$ \(String(item.grossTotal))"
            //            imageView.image = UIImage(named: item.userProfileImageName)
            messageLabel.text = item.status
            l3.text = "ID: \(item.transanctionID)"
            if item.status == "successful"{
                messageLabel.textColor = .systemGreen
            } else {
                messageLabel.textColor = .systemRed
            }
            
            let dateFormatter = DateFormatter()
            if let date = item.paymentDate.stringToDate(dateFormat: "yyyy-MM-dd") {
                dateFormatter.dateFormat = "MMM"
                let month = dateFormatter.string(from: date)
                
                dateFormatter.dateFormat = "yyyy"
                let year = dateFormatter.string(from: date)
                
                dateFormatter.dateFormat = "dd"
                let day = dateFormatter.string(from: date)
                
                l1.text = day
                l2.text = month + "\n" + year
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        borderWidth = 1
        borderColor = Theme.accentColor?.withAlphaComponent(0.4)
        layer.cornerRadius = 0
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 14
        let stacks = stack(l1,l2,spacing: 0)
        l2.numberOfLines = 0
        l2.lineBreakMode = .byWordWrapping
        l2.textAlignment = .center
        addSubview(l3)
        stacks.alignment = .center
        imageView.addSubview(stacks)
        stacks.anchor(top: imageView.topAnchor, leading: imageView.leadingAnchor, bottom: imageView.bottomAnchor, trailing: imageView.trailingAnchor, padding:  UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        hstack(imageView.withWidth(64).withHeight(74),
               stack(nameLabel, messageLabel, spacing: 4),
               spacing: 12,
               alignment: .center).withMargins(.allSides(16))
        l3.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,padding:  UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10))
        
        addSeparatorView(leadingAnchor: nameLabel.leadingAnchor)
    }
}
