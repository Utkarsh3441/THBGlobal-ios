//
//  DotCarePlanCell.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 12/08/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//


import LBTATools

class DotCarePlanCell: LBTAListCell<DotCarePlanModelGet> {
    
    let imageView = UIView(backgroundColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
    let l1 = UILabel(text: "13", font: .boldSystemFont(ofSize: 20), textColor: Theme.gradientColorDark!, textAlignment: .center, numberOfLines: 0)
    let l2 = UILabel(text: "Apr 2020", font: .boldSystemFont(ofSize: 11), textColor: Theme.gradientColorDark!)
     let l3 = UILabel(text: "ID: TXT1231N5460", font: .boldSystemFont(ofSize: 15), textColor: .white)
    let nameLabel = UILabel(text: "User name", font: .boldSystemFont(ofSize: 16))
    let messageLabel = UILabel(text: "Hey girl, what's up there? Let's go out and have a drink tonight?", font: .boldSystemFont(ofSize: 14), textColor: .gray, numberOfLines: 2)
    let messageLabel1 = UILabel(text: "Hey girl, what's up there? Let's go out and have a drink tonight?", font: .boldSystemFont(ofSize: 14), textColor: .gray, numberOfLines: 0)
    
    override var item: DotCarePlanModelGet! {
        didSet {
            nameLabel.text = item.name
//            imageView.image = UIImage(named: item.userProfileImageName)
            
            messageLabel.text = item.details_one
            l3.text = item.status
            switch item.status{
            case "ACTIVE":l3.textColor = .systemGreen
            default:
               l3.textColor = .systemOrange
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
        l2.numberOfLines = 0
        l2.lineBreakMode = .byWordWrapping
        l2.textAlignment = .center
        messageLabel1.attributedText = NSAttributedString().createAttributedString(first: "Click to view ", second: "details", fColor: .lightGray, sColor: Theme.accentColor!, fBold: true, sBold: true, fSize: 14, sSize: 14)
        let stacks = stack(l1,l2,spacing: 0)
        addSubview(l3)
        stacks.alignment = .center
        imageView.addSubview(stacks)
        stacks.anchor(top: imageView.topAnchor, leading: imageView.leadingAnchor, bottom: imageView.bottomAnchor, trailing: imageView.trailingAnchor, padding:  UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        
        hstack(imageView.withWidth(54).withHeight(64),
               stack(nameLabel,messageLabel,messageLabel1, spacing: 4),
               spacing: 12,
               alignment: .lastBaseline).withMargins(.allSides(12))
        l3.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,padding:  UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 20))
        
        addSeparatorView(leadingAnchor: nameLabel.leadingAnchor)
    }
}
