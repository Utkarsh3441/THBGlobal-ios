//
//  DotMyMedicationFunctions.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 21/07/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit


class MyMedicationFunctions{
static func createAvailableDoctors(doctorModel: DoctorModel) {
        MyData.doctorModelArray.append(doctorModel)
    }
 static func readMyMedicine(complition: @escaping () -> ()) {
        // Replace with real data code
        DispatchQueue.global(qos: .userInteractive).async {
            if MyData.myMedicineModelArray.count == 0
            {
                MyData.myMedicineModelArray = MockData.createMockMedicne()
//                Data.tripModelArray.append(TripModel(title: "GOA"))
//                Data.tripModelArray.append(TripModel(title: "COORG"))
//                Data.tripModelArray.append(TripModel(title: "GOKARNA"))
             
            }
            DispatchQueue.main.async {
                complition()
            }
        }
        
    }
}
