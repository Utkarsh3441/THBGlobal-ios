//
//  MockData.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 11/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation

class MockData {
    static func createMockAppointment() -> [DotAppointmentModel] {
        var mockAppointments = [DotAppointmentModel]()
        mockAppointments.append(DotAppointmentModel(hospitalName: "American Hospital", doctorName: "Dr. Anna Jhonshon, ENT", issue: "Nose Bleeding", date: Date(), time: String(describing: Date().timeIntervalSinceNow), status: "Scheduled",appointmentDetailModel:createAppointmentModelData()))
         mockAppointments.append(DotAppointmentModel(hospitalName: "American Hospital1", doctorName: "Dr. Anna Jhonshon, ENT", issue: "Nose Bleeding", date: Date(), time: String(describing: Date().timeIntervalSinceNow), status: "Attended",appointmentDetailModel:createAppointmentModelData()))
         mockAppointments.append(DotAppointmentModel(hospitalName: "American Hospital2", doctorName: "Dr. Anna Jhonshon, ENT", issue: "Nose Bleeding", date: Date(), time: String(describing: Date().timeIntervalSinceNow), status: "Missed",appointmentDetailModel:createAppointmentModelData()))
         mockAppointments.append(DotAppointmentModel(hospitalName: "American Hospital", doctorName: "Dr. Anna Jhonshon, ENT", issue: "Nose Bleeding", date: Date(), time: String(describing: Date().timeIntervalSinceNow), status: "Scheduled",appointmentDetailModel:createAppointmentModelData()))
         mockAppointments.append(DotAppointmentModel(hospitalName: "American Hospital", doctorName: "Dr. Anna Jhonshon, ENT", issue: "Nose Bleeding", date: Date(), time: String(describing: Date().timeIntervalSinceNow), status: "Scheduled",appointmentDetailModel:createAppointmentModelData()))
         mockAppointments.append(DotAppointmentModel(hospitalName: "American Hospital", doctorName: "Dr. Anna Jhonshon, ENT", issue: "Nose Bleeding", date: Date(), time: String(describing: Date().timeIntervalSinceNow), status: "Scheduled",appointmentDetailModel:createAppointmentModelData()))
        
        return mockAppointments
        
    }
    static func createAppointmentModelData() -> [AppointmentDetailModel]{
        var apointmentDetailModel = [AppointmentDetailModel]()
        
        apointmentDetailModel.append(AppointmentDetailModel(status: "Scheduled", facilityName: "Fac Name", address: "Ghar", date: Date(), time: Date(), clinician: "Clinical name", complaints: "Comliant type", coordinator: "My coordinator", remarks: "Good", speciality: "ENT"))
        apointmentDetailModel.append(AppointmentDetailModel(status: "Attended", facilityName: "Fac Name", address: "Ghar", date: Date(), time: Date(), clinician: "Clinical name", complaints: "Comliant type", coordinator: "My coordinator", remarks: "Good", speciality: "ENT"))
        apointmentDetailModel.append(AppointmentDetailModel(status: "Missed", facilityName: "Fac Name", address: "Ghar", date: Date(), time: Date(), clinician: "Clinical name", complaints: "Comliant type", coordinator: "My coordinator", remarks: "Good", speciality: "ENT"))
        apointmentDetailModel.append(AppointmentDetailModel(status: "Attended", facilityName: "Fac Name", address: "Ghar", date: Date(), time: Date(), clinician: "Clinical name", complaints: "Comliant type", coordinator: "My coordinator", remarks: "Good", speciality: "ENT"))
        apointmentDetailModel.append(AppointmentDetailModel(status: "Attended", facilityName: "Fac Name", address: "Ghar", date: Date(), time: Date(), clinician: "Clinical name", complaints: "Comliant type", coordinator: "My coordinator", remarks: "Good", speciality: "ENT"))
        apointmentDetailModel.append(AppointmentDetailModel(status: "Attended", facilityName: "Fac Name", address: "Ghar", date: Date(), time: Date(), clinician: "Clinical name", complaints: "Comliant type", coordinator: "My coordinator", remarks: "Good", speciality: "ENT"))
       
        return apointmentDetailModel
    }
    static func createMockDoctors()->[DoctorModel]{
         var mockDoctorModel = [DoctorModel]()
        mockDoctorModel.append(DoctorModel(name: "Dr. Naeem Modin", speciality: "Orthodontist", hospitalName: "NOA Dental Clinic", price: "$50"))
        mockDoctorModel.append(DoctorModel(name: "Dr. Roy Thomas", speciality: "Oral Surgeon", hospitalName: "NOA Dental Clinic", price: "$100"))
         mockDoctorModel.append(DoctorModel(name: "Dr. Anupama", speciality: "Dentist", hospitalName: "NOA Dental Clinic", price: "$40"))
        mockDoctorModel.append(DoctorModel(name: "Dr. Lelde Sire", speciality: "Beauty Therapist", hospitalName: "Florentia Clinic", price: "$90"))
        mockDoctorModel.append(DoctorModel(name: "Dr. Amin", speciality: "Urologist", hospitalName: "Novomed centers", price: "$50"))
         mockDoctorModel.append(DoctorModel(name: "Dr. Ali Reza", speciality: "General Surgeon", hospitalName: "King's College Hospital", price: "$30"))
        
        return mockDoctorModel
    }
    
}
