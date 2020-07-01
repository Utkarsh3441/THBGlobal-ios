//
//  DotDoctorFunctions.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 18/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class doctorFunctions{
static func createAvailableDoctors(doctorModel: DoctorModel) {
        MyData.doctorModelArray.append(doctorModel)
    }
 static func readDoctors(complition: @escaping () -> ()) {
        // Replace with real data code
        DispatchQueue.global(qos: .userInteractive).async {
            if MyData.doctorModelArray.count == 0
            {
                MyData.doctorModelArray = MockData.createMockDoctors()
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
