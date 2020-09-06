//
//  DotAppointmentsViewController.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 07/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol TalkToDoctorProtocol {
    func buttonTapped()
}

class DotAppointmentsViewController: UIViewController {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnEndDate: UIButton!
    
    var startDate: Date?
    var endDate: Date?
    
    @IBOutlet weak var addAppointmentButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    // var calenderPopover = DotCalenderViewController()
    var itemName: String?
    var keyArray = ["appointment_info","appointment_provider_info","appointment_slot_info"]
    @IBOutlet weak var appointmentTableView: UITableView!
    private let client = DotConnectionClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        //  Bundle.main.loadNibNamed("DotAppointmentsViewController", owner: self, options: nil)
        guard let vc = Bundle.main.classNamed("Asha_Cares.DotDashboardViewController") as? DotDashboardViewController.Type else{return}
        let vire = vc.init()
        
        vire.check()
        setUpSelectDateButton(button: btnStartDate)
        setUpSelectDateButton(button: btnEndDate)

        appointmentTableView.dataSource = self
        appointmentTableView.delegate = self
        appointmentTableView.rowHeight = 120
        appointmentTableView.allowsMultipleSelection = false
        self.navigationItem.title = itemName
        self.searchButton.createFloatingActionButton()
        self.addAppointmentButton.createFloatingActionButton()
        appointmentTableView.tableFooterView = UIView()
        getAppointments()
    }
    
    func setUpSelectDateButton(button:UIButton) {
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
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
            let selectedAppointment =  MyData.appointmentModelArray[indexOfselectedRow]
            /* if let appointmentDetailModel = selectedAppointment.appointmentDetailModel[indexOfselectedRow] as? AppointmentDetailModel{
             appointmentDetailsVC.detailsSetup(appointmentDetailModel: appointmentDetailModel)
             }*/
        }
        
        
        
    }
    
    /// Returns block which will be call on date selection completion of calender
    func datePickerHandler(buttonTag:Int) -> ((Date?, IndexPath)-> Void) {
        return { [weak self](date, indexPath) in
            let dateFormater = DateFormatter()
            dateFormater.dateStyle = .medium
            if let date = date {
                if buttonTag == 0 {
                    self?.startDate = date
                    if self?.fetchDataForSelectedDates() == true {
                      self?.btnStartDate.setTitle(dateFormater.string(from: date), for: .normal)
                    }
                } else if buttonTag == 1 {
                    self?.endDate = date
                    if self?.fetchDataForSelectedDates() == true {
                    self?.btnEndDate.setTitle(dateFormater.string(from: date), for: .normal)
                    }
                }
            }
        }
    }
    
        
    func fetchDataForSelectedDates()->Bool {
        if let startDate = startDate, let endDate = endDate {
            if startDate > endDate {
                DispatchQueue.main.async {
                    self.showAlertView("Alert", message: "Start date can not be less then end date.")

                }
                return false
            }
        }
        return true
  }

    @IBAction func dateActionTappedd(_ sender: UIButton) {
        
        let viewController = UIStoryboard.init(name: "DotAppointmentsViewController", bundle: Bundle.main).instantiateViewController(withIdentifier: "DatePickerController") as? DatePickerController
        
        viewController?.modalPresentationStyle = .custom
        //  viewController?.maxDate = Date()
        viewController?.handler = datePickerHandler(buttonTag: sender.tag)
        
        AppDelegate.delegate.window!.rootViewController!.present(viewController!, animated: true, completion: nil)
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        if let startDate = startDate, let endDate = endDate {
            let startDate =   UtilityFunctions.getTFormattedDate(date:startDate)
            let endDate =   UtilityFunctions.getTFormattedDate(date:endDate)
            getAppointments(startDate: startDate, endDate: endDate)
        } else {
            self.showAlertView("Alert", message: "Please select start date and end date.")
        }
        
        
        
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
        let selectedAppointment = MyData.appointmentModelArray[indexPath.row]
        let storyboard = UIStoryboard(name: String(describing: DotAppointmentDetailsViewController.self), bundle: nil)
        let nextViewController =  storyboard.instantiateInitialViewController() as! DotAppointmentDetailsViewController
        
        let _ = nextViewController.view
        nextViewController.detailsSetup(appointmentDetailModel: MyData.appointmentModelArray[indexPath.row])
        nextViewController.talkProtocol = self
        self.present(nextViewController, animated: true, completion: nil)
        
        
        
    }
    
    
}

extension DotAppointmentsViewController: TalkToDoctorProtocol {
    func buttonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DotAppointmentsViewController{
    
    func getAppointments(startDate:String = "", endDate:String = ""){
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.custom)
        // Query item for doc
        var errorMessage = ""
        var queryItem = [URLQueryItem]()
        if startDate.count > 0 && endDate.count > 0 {
            queryItem = [ URLQueryItem(name: "userId", value:"\(loginData.user_id ?? 17)"), URLQueryItem(name: "userType", value: "patients"),URLQueryItem(name: "startDate", value:"\(startDate)"),URLQueryItem(name: "endDate", value:"\(endDate)")]
            errorMessage = "No data found for selected date range."
        } else {
            queryItem = [ URLQueryItem(name: "userId", value:"\(loginData.user_id ?? 17)"), URLQueryItem(name: "userType", value: "patients")]
            errorMessage = "No Appointments Booked."


        }
        let urlString = "appointments"
        
        // Query item for facility
        let api : API = .api1
        let endpoint: Endpoint = api.getPostAPIEndpointForAppointments(urlString: "\(api.rawValue)\(urlString)", queryItems: queryItem, headers: nil, body: nil)
        
        
        client.callAPI(with: endpoint.request, modelParser: String.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model2Result):
                SVProgressHUD.dismiss()
                if let appointmentData = (model2Result as? NSDictionary)?.value(forKey: "data") as? NSArray, appointmentData.count > 0 {
                    appointmentFunctions.readAppointments(appointmentArray: appointmentData, complition: {[unowned self] in
                        
                        self.appointmentTableView.reloadData()
                        
                    })
                }
                else{
                    print("error occured")
                    SVProgressHUD.dismiss()

                    self.showAlertView("Alert", message: errorMessage)
                    appointmentFunctions.readAppointments(appointmentArray: [], complition: {[unowned self] in
                        self.appointmentTableView.reloadData()
                    })
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                print("the error \(error)")
            }
        }
        
    }
}
