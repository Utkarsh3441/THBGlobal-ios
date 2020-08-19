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
    static func readAppointments(appointmentArray: NSArray,complition: @escaping () -> ()) {
        print(appointmentArray)
        var appointmentArrayToDisplay = [[String:Any]]()
        for appointment in appointmentArray{
            print(appointment)
            if let providerInfo = ((appointment as? NSDictionary)?.value(forKey: "appointment_provider_info")) as? [String:Any], let  appointmentInfo = (appointment as? NSDictionary)?.value(forKey: "appointment_info") as? [String:Any], let appointmentSlotInfo = (appointment as? NSDictionary)?.value(forKey: "appointment_slot_info") as? [String:Any]{
                var appointmentDict = [String:Any]()
                appointmentDict["provider_name"] = providerInfo["provider_name"]
                appointmentDict["provider_type"] = providerInfo["provider_type"]
                appointmentDict["provider_id"] = providerInfo["provider_id"]
                
                appointmentDict["patient_id"] = appointmentInfo["patient_id"]
                appointmentDict["status"] = appointmentInfo["status"]
                 appointmentDict["appointment_id"] = appointmentInfo["appointment_id"]
                appointmentDict["doctor_slot_id"] = appointmentInfo["doctor_slot_id"]
                 appointmentDict["payment_id"] = appointmentInfo["payment_id"]
                appointmentDict["purpose"] = appointmentInfo["purpose"]
                 appointmentDict["remarks"] = appointmentInfo["remarks"]
                
                 appointmentDict["slot_date"] = appointmentSlotInfo["slot_date"]
                 appointmentDict["start_time"] = appointmentSlotInfo["start_time"]
                appointmentDict["end_time"] = appointmentSlotInfo["end_time"]
                
                appointmentArrayToDisplay.append(appointmentDict)
                
            }
    
        }
         print(appointmentArrayToDisplay)
        DispatchQueue.global(qos: .userInteractive).async {
           
            
                MyData.appointmentModelArray = MockData.createMockAppointment(appointmentArray: appointmentArrayToDisplay)
                //                Data.tripModelArray.append(TripModel(title: "GOA"))
                //                Data.tripModelArray.append(TripModel(title: "COORG"))
                //                Data.tripModelArray.append(TripModel(title: "GOKARNA"))
            
            DispatchQueue.main.async {
                complition()
            }
        }
        
    }
        static func readAppointment(by id:Int, complition: @escaping (DotAppointmentModel?) -> () ){
            
            DispatchQueue.global(qos: .userInteractive).async {
                let appointment = MyData.appointmentModelArray.first(where: {$0.patient_id == id})
                DispatchQueue.main.async {
                          complition(appointment)
                      }
            }
          
        }
}
