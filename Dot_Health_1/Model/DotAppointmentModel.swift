//
//  DotAppointmentModel.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 11/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class DotAppointmentModel{
    let id: UUID
    var hospitalName: String
    var doctorName: String
    var issue: String
    var date: Date
    var time: String
    var status: String
    var appointmentDetailModel = [AppointmentDetailModel]()
   
    
    init(hospitalName: String, doctorName: String, issue: String, date: Date, time: String, status: String,appointmentDetailModel : [AppointmentDetailModel] ) {
        id = UUID()
        self.hospitalName = hospitalName
        self.doctorName = doctorName
        self.issue = issue
        self.date = date
        self.time = time
        self.status = status
        self.appointmentDetailModel = appointmentDetailModel
    }
}
