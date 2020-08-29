//
//  DotMyMedicineModel.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 21/07/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation

struct MyMedicineModelResponse:Decodable {
    var message: String?
    var type: String?
    var data: [MyMedicineModel]?
}

struct MyMedicineModel:Decodable {
 
    var days:Int?
    var dosage_instructions:String?
    var drug_name:String?
    var medication_id:Int?
    var medication_type:String?
    var patient_id:Int?
    
    
//    init(appointment_id: Int, days: Int, dosage_instructions: String, drug_name: String, medication_id: Int, patient_id: Int ) {
//        self.appointment_id = appointment_id
//        self.days = days
//        self.dosage_instructions = dosage_instructions
//        self.drug_name = drug_name
//        self.medication_id = medication_id
//        self.patient_id = patient_id
//    }
}
