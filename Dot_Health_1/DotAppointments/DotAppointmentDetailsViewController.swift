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
    var talkProtocol: TalkToDoctorProtocol?
    var appointmentId:UUID?
    var apptDate:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func detailsSetup(appointmentDetailModel: DotAppointmentModel){
       print(appointmentDetailModel)
        self.appointmentStatus = UtilityFunctions.setStatusColor(status: appointmentDetailModel.status, label: self.appointmentStatus)
        self.facilityName.text = appointmentDetailModel.provider_name
        self.address.text = "Not Available"//appointmentDetailModel.address
        self.date.text = appointmentDetailModel.slot_date
        self.time.text = appointmentDetailModel.start_time
        self.clinician.text = "Not Available"//appointmentDetailModel.clinician
        self.speciality.text = appointmentDetailModel.provider_type
        self.complaints.text = appointmentDetailModel.purpose
        self.coordinator.text = "Not Available"// appointmentDetailModel.coordinator
        self.remarks.text = appointmentDetailModel.remarks
    }
    
    @IBAction func talkToDoctorTapped(_ sender: Any) {
        
        UserDefaults.standard.set(true, forKey: "isTalkToDoctorClicked")
        UserDefaults.standard.synchronize()
        talkProtocol?.buttonTapped()
        self.dismiss(animated: true, completion: nil)
//         DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//        for controller in self.navigationController!.viewControllers as Array {
//            if controller.isKind(of: DotDashboardViewController.self) {
//                self.navigationController!.popToViewController(controller, animated: true)
//                break
//            }
//        if let isTalk = UserDefaults.standard.value(forKey: "isTalkToDoctorClicked") as? Bool {
//                 if isTalk == true {
//                     self.navigationController?.popViewController(animated: true)
//                 }
//             }
        }

    
    func addChildViewController(_ views:UIViewController, back: Bool) {
          self.navigationController?.pushViewController(views, animated: true)
          self.navigationController?.navigationBar.barTintColor = Theme.accentColor
          self.navigationController?.navigationBar.tintColor = Theme.tintcolor
          self.navigationController?.navigationBar.isTranslucent = false
        
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
