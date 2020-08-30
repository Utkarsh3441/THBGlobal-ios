//
//  DotAddHabitModel.swift
//  Dot_Health_1
//
//  Created by Utkarsh Agarwal on 8/30/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation

struct DotAddHabitModel {
    var frequency: Int?
    var frequencyUnit: String?
    var habitName: String?
    var habitId: Int?
    var status: String?

    init(dict:Dictionary<String,Any>) {
        frequency = dict.returnIntForKey(key: "habit_frequency")
        frequencyUnit = dict.returnStringForKey(key: "habit_frequency_unit")
        habitName = dict.returnStringForKey(key: "habit_name")
        habitId = dict.returnIntForKey(key: "patient_habit_id")
        status = dict.returnStringForKey(key: "status")
    }
}
//
//struct DotAddHabitModel:Codable,Hashable {
//    var frequency: String?
//    var frequencyUnit: Int?
//    var habitName: String?
//    var habitId: Int?
//    var status: String?
//
//
//
//    private enum CodingKeys : String, CodingKey {
//        case frequency = "habit_frequency"
//        case frequencyUnit = "habit_frequency_unit"
//        case habitName = "habit_name"
//        case habitId = "patient_habit_id"
//        case status
//    }
//
//}
