//
//  MockData.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 11/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation

class MockData {
    static func createMockAppointment(appointmentArray:[[String:Any]]) -> [DotAppointmentModel] {
        var mockAppointments = [DotAppointmentModel]()
        for appointment in appointmentArray{
            mockAppointments.append(DotAppointmentModel(appointment_id: 1, patient_id: 1, doctor_slot_id: 1, facility_slot_id: 1, payment_id: 1, purpose: appointment["purpose"] as? String ?? "Cough", remarks: "Remarks Given", status: appointment["status"] as! String, payment_amount: 1000, provider_id: 1, provider_name: appointment["provider_name"] as? String ?? "Doctor 1", provider_type: appointment["provider_type"] as? String ?? "ENT", slot_date: appointment["slot_date"] as? String ?? "18-Aug-2020", start_time: appointment["start_time"] as? String ?? "02:00", end_time: "02:45"))
        }
    //    mockAppointments.append(DotAppointmentModel(appointment_id: 1, patient_id: 1, doctor_slot_id: 1, facility_slot_id: 1, payment_id: 1, purpose: "Nose Bleeding", remarks: "Remarks Given", status: "Scheduled", payment_amount: 1000, provider_id: 1, provider_name: "Dr. Anna Jhonshon", provider_type: "ENT", slot_date: "18-Aug-2020", start_time: "02:00", end_time: "02:45"))
  /*       mockAppointments.append(DotAppointmentModel(appointment_id: 1, patient_id: 1, doctor_slot_id: 1, facility_slot_id: 1, payment_id: 1, purpose: "Nose Bleeding", remarks: "Remarks Given", status: "Scheduled", payment_amount: 1000, provider_id: 1, provider_name: "Dr. Anna Jhonshon", provider_type: "ENT", slot_date: "6 Aug 2020", start_time: "02:00", end_time: "02:45"))
         mockAppointments.append(DotAppointmentModel(appointment_id: 1, patient_id: 1, doctor_slot_id: 1, facility_slot_id: 1, payment_id: 1, purpose: "Nose Bleeding", remarks: "Remarks Given", status: "Scheduled", payment_amount: 1000, provider_id: 1, provider_name: "Dr. Anna Jhonshon", provider_type: "ENT", slot_date: "6 Aug 2020", start_time: "02:00", end_time: "02:45"))
         mockAppointments.append(DotAppointmentModel(appointment_id: 1, patient_id: 1, doctor_slot_id: 1, facility_slot_id: 1, payment_id: 1, purpose: "Nose Bleeding", remarks: "Remarks Given", status: "Scheduled", payment_amount: 1000, provider_id: 1, provider_name: "Dr. Anna Jhonshon", provider_type: "ENT", slot_date: "6 Aug 2020", start_time: "02:00", end_time: "02:45"))
        mockAppointments.append(DotAppointmentModel(hospitalName: "American Hospital", doctorName: "Dr. Anna Jhonshon, ENT", issue: "Nose Bleeding", date: Date(), time: String(describing: Date().timeIntervalSinceNow), status: "Scheduled",appointmentDetailModel:createAppointmentModelData()))
         mockAppointments.append(DotAppointmentModel(hospitalName: "American Hospital1", doctorName: "Dr. Anna Jhonshon, ENT", issue: "Nose Bleeding", date: Date(), time: String(describing: Date().timeIntervalSinceNow), status: "Attended",appointmentDetailModel:createAppointmentModelData()))
         mockAppointments.append(DotAppointmentModel(hospitalName: "American Hospital2", doctorName: "Dr. Anna Jhonshon, ENT", issue: "Nose Bleeding", date: Date(), time: String(describing: Date().timeIntervalSinceNow), status: "Missed",appointmentDetailModel:createAppointmentModelData()))
         mockAppointments.append(DotAppointmentModel(hospitalName: "American Hospital", doctorName: "Dr. Anna Jhonshon, ENT", issue: "Nose Bleeding", date: Date(), time: String(describing: Date().timeIntervalSinceNow), status: "Scheduled",appointmentDetailModel:createAppointmentModelData()))
         mockAppointments.append(DotAppointmentModel(hospitalName: "American Hospital", doctorName: "Dr. Anna Jhonshon, ENT", issue: "Nose Bleeding", date: Date(), time: String(describing: Date().timeIntervalSinceNow), status: "Scheduled",appointmentDetailModel:createAppointmentModelData()))
         mockAppointments.append(DotAppointmentModel(hospitalName: "American Hospital", doctorName: "Dr. Anna Jhonshon, ENT", issue: "Nose Bleeding", date: Date(), time: String(describing: Date().timeIntervalSinceNow), status: "Scheduled",appointmentDetailModel:createAppointmentModelData()))
        */
        
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
        mockDoctorModel.append(DoctorModel(doctor_id: 1, name: "Dr. Naeem Modin", dob: "25 March 1996", gender: "Male", email: "example@gmail.com", phone: "9090909090", facility_id: 1, city: "Banglore", pincode: "788005", address1: "Address1", address2: "Address2", country: "India", state: "karnataka"))
           mockDoctorModel.append(DoctorModel(doctor_id: 1, name: "Dr. Naeem Modin", dob: "25 March 1996", gender: "Male", email: "example@gmail.com", phone: "9090909090", facility_id: 1, city: "Banglore", pincode: "788005", address1: "Address1", address2: "Address2", country: "India", state: "karnataka"))
           mockDoctorModel.append(DoctorModel(doctor_id: 1, name: "Dr. Naeem Modin", dob: "25 March 1996", gender: "Male", email: "example@gmail.com", phone: "9090909090", facility_id: 1, city: "Banglore", pincode: "788005", address1: "Address1", address2: "Address2", country: "India", state: "karnataka"))
           mockDoctorModel.append(DoctorModel(doctor_id: 1, name: "Dr. Naeem Modin", dob: "25 March 1996", gender: "Male", email: "example@gmail.com", phone: "9090909090", facility_id: 1, city: "Banglore", pincode: "788005", address1: "Address1", address2: "Address2", country: "India", state: "karnataka"))
      /*  mockDoctorModel.append(DoctorModel(name: "Dr. Naeem Modin", speciality: "Orthodontist", hospitalName: "NOA Dental Clinic", price: "$50"))
        mockDoctorModel.append(DoctorModel(name: "Dr. Roy Thomas", speciality: "Oral Surgeon", hospitalName: "NOA Dental Clinic", price: "$100"))
         mockDoctorModel.append(DoctorModel(name: "Dr. Anupama", speciality: "Dentist", hospitalName: "NOA Dental Clinic", price: "$40"))
        mockDoctorModel.append(DoctorModel(name: "Dr. Lelde Sire", speciality: "Beauty Therapist", hospitalName: "Florentia Clinic", price: "$90"))
        mockDoctorModel.append(DoctorModel(name: "Dr. Amin", speciality: "Urologist", hospitalName: "Novomed centers", price: "$50"))
         mockDoctorModel.append(DoctorModel(name: "Dr. Ali Reza", speciality: "General Surgeon", hospitalName: "King's College Hospital", price: "$30"))
        */
        return mockDoctorModel
    }
    
    static func createMockFacility()->[FacilityModel]{
        var mockDoctorModel = [FacilityModel]()
        mockDoctorModel.append(FacilityModel(name: "FacilityName", doe: "25 aug 1990", type: "Type1", email: "example@gamil.com", phone: "9090909090", facility_id: 1, city: "Banglore", pincode: "768005", address1: "Address1", address2: "Address2", country: "India", state: "karnataka"))
            mockDoctorModel.append(FacilityModel(name: "FacilityName", doe: "25 aug 1990", type: "Type1", email: "example@gamil.com", phone: "9090909090", facility_id: 1, city: "Banglore", pincode: "768005", address1: "Address1", address2: "Address2", country: "India", state: "karnataka"))
            mockDoctorModel.append(FacilityModel(name: "FacilityName", doe: "25 aug 1990", type: "Type1", email: "example@gamil.com", phone: "9090909090", facility_id: 1, city: "Banglore", pincode: "768005", address1: "Address1", address2: "Address2", country: "India", state: "karnataka"))
            mockDoctorModel.append(FacilityModel(name: "FacilityName", doe: "25 aug 1990", type: "Type1", email: "example@gamil.com", phone: "9090909090", facility_id: 1, city: "Banglore", pincode: "768005", address1: "Address1", address2: "Address2", country: "India", state: "karnataka"))
            mockDoctorModel.append(FacilityModel(name: "FacilityName", doe: "25 aug 1990", type: "Type1", email: "example@gamil.com", phone: "9090909090", facility_id: 1, city: "Banglore", pincode: "768005", address1: "Address1", address2: "Address2", country: "India", state: "karnataka"))
        return mockDoctorModel
    }
    static func createMockMedicne()->[MyMedicineModel]{
        var mockMedicineModel = [MyMedicineModel]()
        mockMedicineModel.append(MyMedicineModel(appointment_id: 1, days: 4, dosage_instructions: "2 times a day", drug_name: "Paracetamol", medication_id: 1, patient_id: 1))
     /*   mockMedicineModel.append(MyMedicineModel(name: "Paracetamol", speciality: "10 Days", hospitalName: "2 times", price: "$50"))
        mockMedicineModel.append(MyMedicineModel(name: "Paracetamol", speciality: "10 Days", hospitalName: "2 times", price: "$50"))
        mockMedicineModel.append(MyMedicineModel(name: "Paracetamol", speciality: "10 Days", hospitalName: "2 times", price: "$50"))
        mockMedicineModel.append(MyMedicineModel(name: "Paracetamol", speciality: "10 Days", hospitalName: "2 times", price: "$50"))
        mockMedicineModel.append(MyMedicineModel(name: "Paracetamol", speciality: "10 Days", hospitalName: "2 times", price: "$50"))
        mockMedicineModel.append(MyMedicineModel(name: "Paracetamol", speciality: "10 Days", hospitalName: "2 times", price: "$50"))
        */
        return mockMedicineModel
    }
    
}
