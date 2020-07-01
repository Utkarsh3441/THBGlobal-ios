//
//  Model1.swift, Model2.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 02/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation

struct Model1: Decodable {
    let key1: String?
    let key2: String?
    let key3: String?
    let key4: String?
    let key5: String?
    let key6: String?
}

struct Model2: Decodable {
    let results: [Model1]?
}
