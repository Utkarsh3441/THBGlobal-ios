//
//  DotCarePlanModel.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 12/08/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation


struct DotCarePlanModel {
    var appointment_id: Int?
    var care_plan_id: Int?
    var careplan_date: String?
    var details_four: String?
    var details_one: String?
    var details_three: String?
    var details_two: String?
    var name: String?
    var patient_id: Int?

    init(dict:Dictionary<String,Any>) {
     appointment_id = dict.returnIntForKey(key: "appointment_id")
     care_plan_id = dict.returnIntForKey(key: "care_plan_id")
     careplan_date = dict.returnStringForKey(key: "careplan_date")
     details_four = dict.returnStringForKey(key: "details_four")
     details_one = dict.returnStringForKey(key: "details_one")
     details_three = dict.returnStringForKey(key: "details_three")
     details_two = dict.returnStringForKey(key: "details_two")
     name = dict.returnStringForKey(key: "name")
     patient_id = dict.returnIntForKey(key: "patient_id")
     }
 }

