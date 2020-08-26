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
            mockAppointments.append(DotAppointmentModel(appointment_id: appointment["appointment_id"] as? Int ?? 0, patient_id: appointment["patient_id"] as? Int ?? 0, doctor_slot_id: appointment["doctor_slot_id"] as? Int ?? 0, facility_slot_id: appointment["facility_slot_id"] as? Int ?? 0, payment_id: appointment["payment_id"] as? Int ?? 0, purpose: appointment["purpose"] as? String ?? "Not Available", remarks:appointment["remarks"] as? String ?? "Not Available", status: appointment["status"] as? String ?? "Not Available", payment_amount: 1000, provider_id: appointment["provider_id"] as? Int ?? 0, provider_name: appointment["provider_name"] as? String ?? "Not Available", provider_type: appointment["provider_type"] as? String ?? "Not Available", slot_date: appointment["slot_date"] as? String ?? "18-Aug-2020", start_time: appointment["start_time"] as? String ?? "Not Available", end_time: appointment["start_time"] as? String ?? "Not Available"))
        }
        
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
//        mockDoctorModel.append(DoctorModel(doctor_id: 1, name: "Dr. Naeem Modin", dob: "25 March 1996", gender: "Male", email: "example@gmail.com", phone: "9090909090", facility_id: 1, city: "Banglore", pincode: "788005", address1: "Address1", address2: "Address2", country: "India", state: "karnataka"))
//           mockDoctorModel.append(DoctorModel(doctor_id: 1, name: "Dr. Naeem Modin", dob: "25 March 1996", gender: "Male", email: "example@gmail.com", phone: "9090909090", facility_id: 1, city: "Banglore", pincode: "788005", address1: "Address1", address2: "Address2", country: "India", state: "karnataka"))
//           mockDoctorModel.append(DoctorModel(doctor_id: 1, name: "Dr. Naeem Modin", dob: "25 March 1996", gender: "Male", email: "example@gmail.com", phone: "9090909090", facility_id: 1, city: "Banglore", pincode: "788005", address1: "Address1", address2: "Address2", country: "India", state: "karnataka"))
//           mockDoctorModel.append(DoctorModel(doctor_id: 1, name: "Dr. Naeem Modin", dob: "25 March 1996", gender: "Male", email: "example@gmail.com", phone: "9090909090", facility_id: 1, city: "Banglore", pincode: "788005", address1: "Address1", address2: "Address2", country: "India", state: "karnataka"))
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
//        mockDoctorModel.append(FacilityModel(name: "FacilityName", doe: "25 aug 1990", type: "Type1", email: "example@gamil.com", phone: "9090909090", facility_id: 1, city: "Banglore", pincode: "768005", address1: "Address1", address2: "Address2", country: "India", state: "karnataka"))
//        mockDoctorModel.append(FacilityModel(name: "FacilityName", doe: "25 aug 1990", type: "Type1", email: "example@gamil.com", phone: "9090909090", facility_id: 1, city: "Banglore", pincode: "768005", address1: "Address1", address2: "Address2", country: "India", state: "karnataka"))
//        mockDoctorModel.append(FacilityModel(name: "FacilityName", doe: "25 aug 1990", type: "Type1", email: "example@gamil.com", phone: "9090909090", facility_id: 1, city: "Banglore", pincode: "768005", address1: "Address1", address2: "Address2", country: "India", state: "karnataka"))
//        mockDoctorModel.append(FacilityModel(name: "FacilityName", doe: "25 aug 1990", type: "Type1", email: "example@gamil.com", phone: "9090909090", facility_id: 1, city: "Banglore", pincode: "768005", address1: "Address1", address2: "Address2", country: "India", state: "karnataka"))
//        mockDoctorModel.append(FacilityModel(name: "FacilityName", doe: "25 aug 1990", type: "Type1", email: "example@gamil.com", phone: "9090909090", facility_id: 1, city: "Banglore", pincode: "768005", address1: "Address1", address2: "Address2", country: "India", state: "karnataka"))
        return mockDoctorModel
    }
    static func createMockMedicne()->[MyMedicineModel]{
        var mockMedicineModel = [MyMedicineModel]()
     //   mockMedicineModel.append(MyMedicineModel(days: 4, dosage_instructions: "2 times a day", drug_name: "Paracetamol", medication_id: 1, patient_id: 1))
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
