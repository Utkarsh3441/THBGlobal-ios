//
//  DotAppointmentDetailViewController.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 15/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class DotAppointmentDetailViewController: UIViewController {

    @IBOutlet weak var appointmentDetailsTableView: UITableView!
    let appointmentDetailTitleArray = ["Status","facilityName","address","date","time","clinician","complaints","coordinator","remarks"]
    var appointmentId : UUID!
       var appointmentModel : DotAppointmentModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        appointmentDetailsTableView.delegate = self
        appointmentDetailsTableView.dataSource = self
        
    }
    



}
extension DotAppointmentDetailViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        appointmentDetailTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DotAppointmentDetailTableViewCell
        print("mukeh:indexpathrow",indexPath.row)
       // cell.setup(appointmentModel: MyData.appointmentModelArray[indexPath.row])
        return cell
    }
    
    
}
