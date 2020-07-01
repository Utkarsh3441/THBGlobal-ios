//
//  Test.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 08/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//
import Foundation
import UIKit
import TinyConstraints

class GenericTableViewCell<View: UIView>: UITableViewCell {
  
  var cellView: View? {
    didSet {
      guard cellView != nil else { return }
      setUpViews()
    }
  }
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    backgroundColor = .lightGray
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpViews() {
    guard let cellView = cellView else { return }
        
    addSubview(cellView)
    cellView.edgesToSuperview()
  }
}
