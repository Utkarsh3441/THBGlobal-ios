//
//  DotCardModel.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 08/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation
import UIKit

struct DotCardModel:Hashable{
    var cardName : String?
    var cardTitle : String?
}
struct DotSlotsModel:Hashable{
    var cardName : String?
    var cardTitle : String?
    var isSelect : Bool?
    var id: Int?
}
struct AdddocumentsModel:Hashable{
    var cardName : String?
    var cardTitle : String?
    var selectedImage : UIImage?
   var isSelect : Bool?
    var url : URL?
}
