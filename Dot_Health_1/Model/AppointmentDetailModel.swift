//
//  AppointmentDetailModel.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 15/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation

struct AppointmentDetailModel:Decodable{
    let id:UUID
    var status: String
    var facilityName: String
    var address: String
    var date: Date
    var time: Date
    var clinician: String
    var complaints: String
    var coordinator: String
    var speciality: String
    var remarks: String
    
    init(status: String, facilityName: String, address: String ,date: Date,time: Date,clinician: String,complaints: String,coordinator: String,remarks: String, speciality:String) {
        id = UUID()
        self.status = status
        self.facilityName = facilityName
        self.address = address
        self.date = date
        self.time = time
        self.clinician = clinician
        self.complaints = complaints
        self.coordinator = coordinator
        self.remarks = remarks
        self.speciality = speciality
    }
}
