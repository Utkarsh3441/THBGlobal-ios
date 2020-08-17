//
//  DarkenedHoleView.swift
//  sample-chat-swift
//
//  Created by Injoit on 18.01.2020.
//  Copyright © 2020 quickBlox. All rights reserved.
//

import UIKit
import Foundation

class DarkenedHoleView: UIView {
    var transparentHoleView: UIView?
    
    private lazy var roundingCorners: UIRectCorner = {
        let roundingCorners = UIRectCorner()
        return roundingCorners
    }()
    var isIncoming = false
    var cornerRad: CGFloat = 0.0
    var isHasAttachmeht = false
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let transparentHoleView = transparentHoleView else {
            return
        }
        cornerRad = isHasAttachmeht == true ? 6.0 : 20.0
        self.backgroundColor?.setFill()
        UIRectFill(rect)
        let layer = CAShapeLayer()
        let path = CGMutablePath()
        if isIncoming == false {
            roundingCorners = [.bottomLeft, .topLeft, .topRight]
        } else {
            roundingCorners = [.topLeft, .topRight, .bottomRight]
        }
        let bPath = UIBezierPath(roundedRect: transparentHoleView.frame,
                                 byRoundingCorners: roundingCorners,
                                 cornerRadii: CGSize(width: cornerRad, height: cornerRad))
        
        path.addPath(bPath.cgPath)
        path.addRect(bounds)
        
        layer.path = path
        layer.fillRule = CAShapeLayerFillRule.evenOdd
        self.layer.mask = layer
    }
}
