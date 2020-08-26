//
//  DotData.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 11/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation

class MyData{
    static var appointmentModelArray = [DotAppointmentModel]()
    static var doctorModelArray = [DoctorModel]()
    static var facilityModelArray = [FacilityModel]()
    static var myMedicineModelArray = [MyMedicineModel]()
    static var patientDetails: registerModel?

}
class loginData{
    static var user_email:String?
    static var user_id:Int?
    static var user_name:String?
    static var user_type:String?
}
struct loginDetails:Codable,Hashable{
     var user_email:String?
     var user_id:Int?
     var user_name:String?
     var user_type:String?
}
struct networkModel:Codable,Hashable {
    var data:[loginDetails]
    var description:String?
    var message:String?
    var type:String?
}
