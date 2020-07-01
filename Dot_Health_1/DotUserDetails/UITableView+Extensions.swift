//
//  UITableView.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 08/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.

import Foundation
import UIKit

extension UITableView {
  func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
    register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
  }
  
  func dequeueReusableCell<Cell: UITableViewCell>(forIndexPath indexPath: IndexPath) -> Cell {
    let identifier = String(describing: Cell.self)
    guard let cell = self.dequeueReusableCell(withIdentifier: identifier,
                                              for: indexPath) as? Cell else {
      fatalError("Error for cell id: \(identifier) at \(indexPath))")
    }
    return cell
  }
}
