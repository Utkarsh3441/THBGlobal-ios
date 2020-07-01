//
//  DotAddAppointmentViewController.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 18/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class DotAddAppointmentViewController: UIViewController {

    @IBOutlet weak var ailmentButton: UIButton!
    @IBOutlet weak var doctorButton: UIButton!
    @IBOutlet weak var institutionButton: UIButton!
    @IBOutlet weak var specialityButton: UIButton!
    @IBOutlet weak var doctorListTableView: UITableView!
    var selectedAilment : [String] = []
    @IBOutlet weak var selectedAilmentLabel: UILabel!
    var selectedIndexPath: IndexPath = IndexPath()
    override func viewDidLoad() {
        super.viewDidLoad()
        doctorListTableView.delegate = self
        doctorListTableView.dataSource = self
        doctorListTableView.reloadData()
        
        doctorFunctions.readDoctors(complition: {[unowned self] in
            
            self.doctorListTableView.reloadData()
           
        })
        doctorListTableView.rowHeight = 135
        self.navigationItem.title = "Add Appointments"
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let destination = segue.destination as? DotAilmentViewController  {
               destination.callback = {result in
               self.selectedAilmentLabel.text = result.joined(separator: ", ")
           }
        
        }
        
            if (segue.identifier == "timeSlotView") &&  self.selectedIndexPath.count > 0{
                let viewController = segue.destination as? DotTimeSlotViewController
                viewController?.selectedName = MyData.doctorModelArray[ self.selectedIndexPath.row].name
                viewController?.selectedSpec = MyData.doctorModelArray[ self.selectedIndexPath.row].speciality
                viewController?.selectedHosPitalName = MyData.doctorModelArray[ self.selectedIndexPath.row].hospitalName
                viewController?.selectedPrice = MyData.doctorModelArray[ self.selectedIndexPath.row].price
                   }
    }
    
    @IBAction func buttonTouched(_ sender: UIButton) {
        
        switch sender.titleLabel?.text {
        case "Ailment":
            sender.createFloatingActionButton()
        case "Doctor":
            sender.createFloatingActionButton()
            self.institutionButton.createNormalButton()
            self.specialityButton.createNormalButton()
        case "Institution":
            sender.createFloatingActionButton()
            self.doctorButton.createNormalButton()
            self.specialityButton.createNormalButton()
        case "Facility":
            sender.createFloatingActionButton()
            self.doctorButton.createNormalButton()
            self.institutionButton.createNormalButton()
        default:
            print("Wrong button")
        }
    }
    


}
extension DotAddAppointmentViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MyData.doctorModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DotDoctorTableViewCell
        cell.setUp(rowIndex: indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        let storyBoard : UIStoryboard = UIStoryboard(name: String(describing: DotTimeSlotViewController.self) , bundle:nil)
              let nextViewController = storyBoard.instantiateInitialViewController() as! DotTimeSlotViewController
       
              let _ = nextViewController.view
//        nextViewController.selectedName = MyData.doctorModelArray[ self.selectedIndexPath.row].name
//        nextViewController.selectedSpec = MyData.doctorModelArray[ self.selectedIndexPath.row].speciality
//        nextViewController.selectedHosPitalName = MyData.doctorModelArray[ self.selectedIndexPath.row].hospitalName
//        nextViewController.priceLabel.text = MyData.doctorModelArray[ self.selectedIndexPath.row].price
        nextViewController.setUpDoctorDetail(rowIndex:indexPath.row)
        self.show(nextViewController, sender: self)
    }
    
}
