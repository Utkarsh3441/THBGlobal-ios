//
//  ProfileDetailModel.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 09/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation
struct ProfileDatamodel: Decodable {
    var name: String?
    var DOB: String?
    var language: String?
    var phone: String?
    var email: String?
    var Emergency: String?
    var mrn:String?
    var title:String?
}
