//
//  DotAppointmentModel.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 11/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

struct DotAppointmentModel:Decodable{
    let appointment_id: Int
    let patient_id: Int
    let doctor_slot_id: Int
    let facility_slot_id: Int
    let payment_id: Int
    let purpose: String
    let remarks: String
    let status: String
    let payment_amount: Int
    let provider_id: Int
    let provider_name: String
    let provider_type: String
    let slot_date : String
    let start_time: String
    let end_time: String
}
