//
//  DotAppointmentsViewController.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 07/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class DotAppointmentsViewController: UIViewController {

    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var searchFieldTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    @IBOutlet weak var addAppointmentButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    var selectedTextField : UITextField?
    var calenderPopover = DotCalenderViewController()
    var itemName: String?
    @IBOutlet weak var appointmentTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
      //  Bundle.main.loadNibNamed("DotAppointmentsViewController", owner: self, options: nil)
         guard let vc = Bundle.main.classNamed("Dot_Health_1.DotDashboardViewController") as? DotDashboardViewController.Type else{return}
        let vire = vc.init()
      
        vire.check()
        startDateTextField.delegate =  self
        endDateTextField.delegate = self
        appointmentTableView.dataSource = self
        appointmentTableView.delegate = self
        appointmentFunctions.readAppointments(complition: {[unowned self] in
            
            self.appointmentTableView.reloadData()
           
        })
        appointmentTableView.rowHeight = 135
        appointmentTableView.allowsMultipleSelection = false
        self.navigationItem.title = itemName
        self.addAppointmentButton.createFloatingActionButton()
    }

    func openDatePicker(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        selectedTextField?.inputView = datePicker
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelButtonAcction))
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonAcction))
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, flexibleButton, doneButton], animated: false)
        selectedTextField?.inputAccessoryView = toolbar
       // endDateTextField.inputAccessoryView = toolbar
    }
    @objc func cancelButtonAcction(){
        selectedTextField?.resignFirstResponder()
      //  endDateTextField.resignFirstResponder()
    }
    @objc func doneButtonAcction(dateTextField:UITextField){
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .medium
        if let datePicker = selectedTextField?.inputView as? UIDatePicker{
            print(datePicker.date)
            selectedTextField?.text = dateFormater.string(from: datePicker.date)
            selectedTextField?.resignFirstResponder()
            
        }
       }
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = CustomShowPopup.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let appointmentDetailsVC = segue.destination as? DotAppointmentDetailsViewController else { return }
        let _ = appointmentDetailsVC.view
        if let cellView = sender as? UITableViewCell,  let indexOfselectedRow = self.appointmentTableView.indexPath(for: cellView)?.row{
           let selectedAppointment = MyData.appointmentModelArray[indexOfselectedRow]
            if let appointmentDetailModel = selectedAppointment.appointmentDetailModel[indexOfselectedRow] as? AppointmentDetailModel{
                      appointmentDetailsVC.detailsSetup(appointmentDetailModel: appointmentDetailModel)
                 }
        }
     
        
      
    }
}
extension DotAppointmentsViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextField = textField
        self.openDatePicker()
        calenderPopover.PopView = textField
        calenderPopover.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
      // showPopup(calenderPopover, sourceView: textField)
    }
}

extension DotAppointmentsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MyData.appointmentModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentCellId") as! DotAppointmentTableViewCell
               cell.setup(appointmentModel: MyData.appointmentModelArray[indexPath.row])
               return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedAppointment = MyData.appointmentModelArray[indexPath.row]
//        let storyboard = UIStoryboard(name: String(describing: DotAppointmentDetailsViewController.self), bundle: nil)
//               let vc =  storyboard.instantiateInitialViewController() as! DotAppointmentDetailsViewController
//               vc.appointmentId = selectedAppointment.id
//        let _ = vc.view
//        if let appointmentDetailModel = selectedAppointment.appointmentDetailModel.first{
//             vc.detailsSetup(appointmentDetailModel: appointmentDetailModel)
//        }
//
        
        
    }
   
}
