//
//  DotAppointmentDetailsViewController.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 17/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class DotAppointmentDetailsViewController: UIViewController {

    @IBOutlet weak var appointmentStatus: UILabel!
    @IBOutlet weak var facilityName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var clinician: UILabel!
    @IBOutlet weak var speciality: UILabel!
    @IBOutlet weak var complaints: UILabel!
    @IBOutlet weak var coordinator: UILabel!
    @IBOutlet weak var remarks: UILabel!
    var appointmentId:UUID?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func detailsSetup(appointmentDetailModel: AppointmentDetailModel){
       print(appointmentDetailModel)
        self.appointmentStatus = UtilityFunctions.setStatusColor(status: appointmentDetailModel.status, label: self.appointmentStatus)
        self.facilityName.text = appointmentDetailModel.facilityName
        self.address.text = appointmentDetailModel.address
        self.date.text = UtilityFunctions.getDateAsString(inputDate: appointmentDetailModel.date)
        self.time.text = UtilityFunctions.getTimeAsString(inputTime: appointmentDetailModel.time)
        self.clinician.text = appointmentDetailModel.clinician
        self.speciality.text = appointmentDetailModel.speciality
        self.complaints.text = appointmentDetailModel.complaints
        self.coordinator.text = appointmentDetailModel.coordinator
        self.remarks.text = appointmentDetailModel.remarks
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
