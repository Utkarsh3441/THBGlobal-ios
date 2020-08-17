//
//  DotPaymentsCell.swift
//  tinder_messages_screen
//
//  Created by Animesh Mohanty on 05/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import LBTATools

class DotPaymentsCell: LBTAListCell<DotPaymentsModel> {
    
    let imageView = UIView(backgroundColor: Theme.gradientColorDark!)
    let l1 = UILabel(text: "13", font: .boldSystemFont(ofSize: 20), textColor: .white, textAlignment: .center, numberOfLines: 0)
    let l2 = UILabel(text: "Apr", font: .systemFont(ofSize: 10), textColor: .white)
     let l3 = UILabel(text: "ID: TXT1231N5460", font: .boldSystemFont(ofSize: 15), textColor: .white)
    let nameLabel = UILabel(text: "User name", font: .boldSystemFont(ofSize: 16))
    let messageLabel = UILabel(text: "Hey girl, what's up there? Let's go out and have a drink tonight?", font: .boldSystemFont(ofSize: 14), textColor: .gray, numberOfLines: 2)
    
    override var item: DotPaymentsModel! {
        didSet {
            nameLabel.text = item.price
//            imageView.image = UIImage(named: item.userProfileImageName)
            messageLabel.text = item.text
            switch item.state{
            case 0:messageLabel.textColor = .systemRed
            case 1:messageLabel.textColor = .systemGreen
            default:
               messageLabel.textColor = .systemOrange
            }
            
        }
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor(hex: Theme.gradientColorLight!.hexValue, alpha: 0.5)
        layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 14
        let stacks = stack(l1,l2,spacing: 0)
        addSubview(l3)
        stacks.alignment = .center
        imageView.addSubview(stacks)
        stacks.anchor(top: imageView.topAnchor, leading: imageView.leadingAnchor, bottom: imageView.bottomAnchor, trailing: imageView.trailingAnchor, padding:  UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        hstack(imageView.withWidth(64).withHeight(64),
               stack(nameLabel, messageLabel, spacing: 4),
               spacing: 12,
               alignment: .center).withMargins(.allSides(16))
        l3.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,padding:  UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 20))
        
        addSeparatorView(leadingAnchor: nameLabel.leadingAnchor)
    }
}
