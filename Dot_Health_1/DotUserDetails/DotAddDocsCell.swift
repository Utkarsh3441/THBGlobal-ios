//
//  DotAddDocsCell.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 17/07/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import TinyConstraints
import Foundation
protocol SelfConfiguredCells{
    static var reuseIdentifier: String { get }
}
class DotAddDocsCell: UICollectionViewCell, SelfConfiguredCells  {
    static var reuseIdentifier: String = "docCell"
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
    lazy var DocumentImageView: UIImageView = {
           let imageView = UIImageView()
           imageView.layer.cornerRadius = 22
           imageView.clipsToBounds = true
           imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
           return imageView
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
        addSubview(DocumentImageView)
        DocumentImageView.edgesToSuperview(insets: .left(5) + .right(5) + .top(5) + .bottom(5))
        DocumentImageView.height(contentView.bounds.height/2 - 30)
        addSubview(nameLabel)
        nameLabel.edgesToSuperview()
      
        
    }
    func changeColor(_ colored:UIColor){
        backgroundColor = colored
    }
}
