//
//  appointmentFunctions.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 11/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class appointmentFunctions{
    static func createAppointment(appointmentModel: DotAppointmentModel) {
            MyData.appointmentModelArray.append(appointmentModel)
        }
     static func readAppointments(complition: @escaping () -> ()) {
            // Replace with real data code
            DispatchQueue.global(qos: .userInteractive).async {
                if MyData.appointmentModelArray.count == 0
                {
                    MyData.appointmentModelArray = MockData.createMockAppointment()
    //                Data.tripModelArray.append(TripModel(title: "GOA"))
    //                Data.tripModelArray.append(TripModel(title: "COORG"))
    //                Data.tripModelArray.append(TripModel(title: "GOKARNA"))
                 
                }
                DispatchQueue.main.async {
                    complition()
                }
            }
            
        }
        static func readAppointment(by id:UUID, complition: @escaping (DotAppointmentModel?) -> () ){
            
            DispatchQueue.global(qos: .userInteractive).async {
                let appointment = MyData.appointmentModelArray.first(where: {$0.id == id})
                DispatchQueue.main.async {
                          complition(appointment)
                      }
            }
          
        }
}
