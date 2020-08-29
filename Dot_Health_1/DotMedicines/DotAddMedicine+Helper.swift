//
//  DotAddMedicine+Helper.swift
//  Dot_Health_1
//
//  Created by Utkarsh Agarwal on 8/29/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation


enum AddMedicineModel: String, CaseIterable {
    case medicineName = "drug_name"
    case prescribedForDays = "days"
    case Prescribed = "medication_type"
    case dosePerDay = "dose_per_day"
    case Instructions = "dosage_instructions"
    case Precautions = "other_instruction"
   
}

