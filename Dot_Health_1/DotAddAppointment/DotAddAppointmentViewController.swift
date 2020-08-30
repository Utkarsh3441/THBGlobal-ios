//
//  DotAddAppointmentViewController.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 18/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit
import FittedSheets
import SVProgressHUD
class DotAddAppointmentViewController: UIViewController {

    @IBOutlet weak var ailmentButton: UIButton!
    @IBOutlet weak var doctorButton: UIButton!
    @IBOutlet weak var specialityButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var doctorListTableView: UITableView!
    @IBOutlet weak var addButton: ActionButton!
    var selectedAilment : [[String:Any]] = []
    @IBOutlet weak var selectedAilmentLabel: UILabel!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewLineHorizontal: UIView!
    
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedIndexPath: IndexPath = IndexPath()
    var searchByDoctor = true
    var screenName : String = kblankString
    let controller = UIStoryboard(name: "DotMedicines", bundle: nil).instantiateInitialViewController() as? DotMedicinesController
     private let client = DotConnectionClient()
    var ailments = [ailment]()
    var services = [service]()
   // var facilityData = [facilityModel]()
    var urlString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewItems()
        doctorListTableView.delegate = self
        doctorListTableView.dataSource = self
        doctorListTableView.reloadData()
        doctorListTableView.rowHeight = 135
        if screenName == "Medications"{
             self.navigationItem.title = "Medications"
             ailmentButton.isHidden = true
             topViewHeightConstraint.constant = 0
             getMedication()
             addButton.isHidden = false
             addButton.createFloatingActionButton()
             searchBarHeightConstraint.constant = 0
            searchBar.isHidden = true
            viewLineHorizontal.isHidden = true
        }
        else{
            getAilments()
            getServices()
            if searchByDoctor == true {
                fetchDoctorsList(searchItem: nil, searchCity: MyData.patientDetails?.patient_city)
            } else {
                fetchFacilityList(searchItem: nil, searchCity: MyData.patientDetails?.patient_city)
            }
            doctorButton.createSelectedOptionButton()
            ailmentButton.setTitle("Ailment", for: .normal)
            self.specialityButton.createOptionButton()
            self.navigationItem.title = "Add Appointments"
            topViewHeightConstraint.constant = 99
        }
        
        
    }
    func configureViewItems(){
        self.doctorButton.createOptionButton()
        self.specialityButton.createOptionButton()
        self.ailmentButton.createOptionButton()
        self.searchButton.createFloatingActionButton()
        ailmentButton.titleLabel?.numberOfLines = 1;
        ailmentButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        ailmentButton.titleLabel?.lineBreakMode = .byClipping;
        searchBar.placeholder = "Search by city"
        searchBar.showsCancelButton = true

    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DotAilmentViewController  {
            destination.preferredContentSize = CGSize(width: self.view.frame.width, height: 500)
            destination.popoverPresentationController?.delegate = self

            switch ailmentButton.titleLabel?.text{
            case "Ailment":
                destination.selectedData = "Ailment"
                destination.ailmentData = ailments
            case "Services":
                destination.selectedData = "Services"
                destination.servicesData = services
            default:
                print("no data found")
            }
            
            destination.callback = {result in
                self.selectedAilment = result
                let ailmetServiceList = result.map({$0["name"] as? String}) as? [String]
                self.selectedAilmentLabel.text = ailmetServiceList?.joined(separator: ", ")
                self.fetchDataForAilment()
            }
            
        }
        
        if (segue.identifier == "timeSlotView") &&  self.selectedIndexPath.count > 0{
            let viewController = segue.destination as? DotTimeSlotViewController
            viewController?.selectedName = MyData.doctorModelArray[ self.selectedIndexPath.row].name ?? ""
            viewController?.selectedSpec = MyData.doctorModelArray[ self.selectedIndexPath.row].country ?? ""
            viewController?.selectedHosPitalName = MyData.doctorModelArray[ self.selectedIndexPath.row].state ?? ""
            if let fees = MyData.doctorModelArray[ self.selectedIndexPath.row].fees {
                viewController?.selectedPrice = "$ \(fees)"
            }
        }
    }
    
    func fetchDataForAilment() {
        
        if selectedAilment.count > 0 {
              print(selectedAilment)
              if searchByDoctor == true {
                  fetchDoctorsList(searchItem: selectedAilment, searchCity: MyData.patientDetails?.patient_city)
              } else {
                  fetchFacilityList(searchItem: selectedAilment, searchCity: MyData.patientDetails?.patient_city)
              }
          }
    }
    
    func searchByQueryItem(searchText:String) {
        if searchByDoctor == true {
            fetchDoctorsList(searchItem: nil, searchCity: searchText)
        }
        else {
            fetchFacilityList(searchItem: nil, searchCity: searchText)
        }
    }
    
    @IBAction func buttonTouched(_ sender: UIButton) {
        switch sender.titleLabel?.text {
        case "Ailment":
            sender.createSelectedOptionButton()
        case "Doctor":
            sender.createSelectedOptionButton()
            ailmentButton.setTitle("Ailment", for: .normal)
            self.specialityButton.createOptionButton()
            searchByDoctor = true
            fetchDoctorsList(searchItem: nil, searchCity: MyData.patientDetails?.patient_city)
            clearSearchAlimentData()
        case "Facility":
            sender.createSelectedOptionButton()
            ailmentButton.setTitle("Services", for: .normal)
            self.doctorButton.createOptionButton()
            searchByDoctor = false
            fetchFacilityList(searchItem: nil, searchCity: MyData.patientDetails?.patient_city)
            clearSearchAlimentData()
        case "Services":
             sender.createSelectedOptionButton()
        default:
            print("Wrong button")
        }
    }
    
    func clearSearchAlimentData() {
        selectedAilment = []
        selectedAilmentLabel.text = ""
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let openDetailsObj = DotAddMedicinesController()
        openDetailsObj.delegate = self
        self.present(openDetailsObj, animated: true, completion: nil)
    }
    

    @IBAction func searchAction(_ sender: UIButton) {
  
    }
    
}



extension DotAddAppointmentViewController: addMedicineTableDelegate {
    func refreshTable(data: [String : AnyObject]) {
        getMedication()
//        profileData = data
//        detailSections.reloadData()
//        NotificationCenter.default.post(name: Notification.Name("ProfileDataUpdated"), object: nil)
    }
}

//MARK:API CAlls
extension DotAddAppointmentViewController {
    func getMedication(){
        SVProgressHUD.show()
        let api: API = .api1
        let endpoint: Endpoint = api.getPostAPIEndpointForMedication(urlString: "\(api.rawValue)patients/\(loginData.user_id ?? 17)/medications", queryItems: nil, headers: nil, body: nil)
        client.callAPI(with: endpoint.request, modelParser: MyMedicineModelResponse.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model2Result):
                SVProgressHUD.dismiss()
                if let model = model2Result as? MyMedicineModelResponse, model.type == "Success", let medicineModel = model.data {
                    MyData.myMedicineModelArray = medicineModel
                    self.doctorListTableView.reloadData()
                    print("Fetched Medicines:",MyData.myMedicineModelArray)
                }
                else{
                    print("error occured")
                    SVProgressHUD.dismiss()
                }
            case .failure(let error):
                
                SVProgressHUD.dismiss()
                if case let APIError.errorAllResponse(description, message, _) = error {
                    self.showAlertView(message, message: description)
                }
            }
        }
        
    }
    func getServices(){
        
        let api : API = .api1
            let endpoint: Endpoint = api.getPostAPIEndpointForAppointments(urlString: "\(api.rawValue)services", queryItems: nil, headers: nil, body: nil)
            client.callAPI(with: endpoint.request, modelParser: [service].self) { [weak self] result in
            guard let self = self else { return }
                switch result {
                case .success(let model2Result):
                    SVProgressHUD.dismiss()
                    if let model = model2Result as? [service]{
                        self.services = model
                    }
                    else{
                        print("error occured")
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    if case let APIError.errorAllResponse(description, message, _) = error {
                        self.showAlertView(message, message: description)
                    }
                }
        }
    }
    func getAilments(){
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.custom)
        let api : API = .api1
        let endpoint: Endpoint = api.getPostAPIEndpointForAppointments(urlString: "\(api.rawValue)ailments", queryItems: nil, headers: nil, body: nil)
        client.callAPI(with: endpoint.request, modelParser: [ailment].self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model2Result):
                
                if let model = model2Result as? [ailment]{
                    self.ailments = model
                }
                else{
                    print("error occured")
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                if case let APIError.errorAllResponse(description, message, _) = error {
                    self.showAlertView(message, message: description)
                }
            }
        }
    }
    
    func fetchFacilityList(searchItem:[[String:Any]]?, searchCity: String?) {
        
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.custom)
        
        urlString = "facilities"
        
        var queryItem: [URLQueryItem]?
        if let item = searchItem?.first?["name"] as? String, let id = searchItem?.first?["id"] as? Int {
            if services.contains(where: {$0.service == item}){
                queryItem = [URLQueryItem(name: "serviceId", value:"\(id)")]
            }
        }
        if let text = searchCity , text.count > 0 {
            if queryItem != nil {
                queryItem?.append(URLQueryItem(name: "city", value:"\(text)"))
            }
            else {
                queryItem = [URLQueryItem(name: "city", value:"\(text)")]
            }
        }
        
        let api : API = .api1
        let endpoint: Endpoint = api.getPostAPIEndpointForAppointments(urlString: "\(api.rawValue)\(urlString)", queryItems: queryItem, headers: nil, body: nil)
        
        client.callAPI(with: endpoint.request, modelParser: FacilityModelResponse.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model2Result):
                
                SVProgressHUD.dismiss()
                if let model = model2Result as? FacilityModelResponse, model.type == "Success", let facilityModel = model.data {
                    MyData.facilityModelArray = facilityModel
                    print("Fetched facility:",MyData.facilityModelArray)
                    self.doctorListTableView.reloadData()
                    SVProgressHUD.dismiss()
                }
                else{
                    facilityFunctions.readFacilities(complition: {[unowned self] in
                        
                        self.doctorListTableView.reloadData()
                        
                    })
                    print("error occured")
                    SVProgressHUD.dismiss()
                }
            case .failure(let error):
                
                SVProgressHUD.dismiss()
                if case let APIError.errorAllResponse(description, message, _) = error {
                    self.showAlertView(message, message: description)
                }
                print("the error \(error)")
            }
        }
    }
    
    func fetchDoctorsList(searchItem:[[String:Any]]?, searchCity: String?) {
        
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.custom)
                        
        urlString = "doctors"
   
        var queryItem: [URLQueryItem]?
        if let item = searchItem?.first?["name"] as? String, let id = searchItem?.first?["id"] as? Int {
            if ailments.contains(where: {$0.ailment == item}){
                queryItem = [URLQueryItem(name: "ailmentId", value:"\(id)")]
            }
        }
        
        if let text = searchCity , text.count > 0 {
            if queryItem != nil {
                queryItem?.append(URLQueryItem(name: "city", value:"\(text)"))
            }
            else {
                queryItem = [URLQueryItem(name: "city", value:"\(text)")]
            }
        }
                        
            // Query item for facility
            let api : API = .api1
            let endpoint: Endpoint = api.getPostAPIEndpointForAppointments(urlString: "\(api.rawValue)\(urlString)", queryItems: queryItem, headers: nil, body: nil)
            
            client.callAPI(with: endpoint.request, modelParser: DoctorModelResponse.self) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let model2Result):
                    SVProgressHUD.dismiss()
                    if let model = model2Result as? DoctorModelResponse, model.type == "Success", let doctorModel = model.data {
                        MyData.doctorModelArray = doctorModel
                        print("Fetched doctor:",MyData.doctorModelArray)
                        self.doctorListTableView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                    else{
                        doctorFunctions.readDoctors(complition: {[unowned self] in
                            
                            self.doctorListTableView.reloadData()
                            
                        })
                        print("error occured")
                        SVProgressHUD.dismiss()
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    if case let APIError.errorAllResponse(description, message, _) = error {
                        self.showAlertView(message, message: description)
                    }
                    print("the error \(error)")
                }
            }
    }
}
//MARK:TableView Delegates
extension DotAddAppointmentViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if screenName == "Medications"{
            return   MyData.myMedicineModelArray.count
        }
        else if urlString == "facilities"{
            return  MyData.facilityModelArray.count
        }
        return MyData.doctorModelArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DotDoctorTableViewCell
        if screenName == "Medications"{
             cell.setUp(rowIndex: indexPath.row,dataArray: MyData.myMedicineModelArray)
        }
        else if urlString == "facilities"{
             cell.setUp(rowIndex: indexPath.row,dataArray: MyData.facilityModelArray)
        }
        else{
            cell.setUp(rowIndex: indexPath.row,dataArray: MyData.doctorModelArray)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        
        if screenName == "Medications"{
            controller?.selectedModel = MyData.myMedicineModelArray[indexPath.row]
            controller?.makeDateArr()
            let sheetController = SheetViewController(controller: controller ?? UIViewController(), sizes: [.fixed(350), .halfScreen])
            
            sheetController.adjustForBottomSafeArea = false
            sheetController.blurBottomSafeArea = true
            sheetController.dismissOnBackgroundTap = true
            sheetController.extendBackgroundBehindHandle = false
            sheetController.topCornersRadius = 15
            
            
            sheetController.willDismiss = { _ in
                print("Will dismiss ")
            }
            sheetController.didDismiss = { _ in
                print("Will dismiss ")
            }
            DispatchQueue.main.async {
                self.present(sheetController, animated: false, completion: nil)
            }
        }
        else{
            let storyBoard : UIStoryboard = UIStoryboard(name: String(describing: DotTimeSlotViewController.self) , bundle:nil)
            let nextViewController = storyBoard.instantiateInitialViewController() as! DotTimeSlotViewController
           let _ = nextViewController.view
        
        if searchByDoctor == true {
            nextViewController.selectedDoctorId = MyData.doctorModelArray[indexPath.row].doctor_id
            nextViewController.setUpDoctorDetail(rowIndex:indexPath.row)
        }
        else {
            nextViewController.isFacilitySelected = true
            nextViewController.setUpFacilityDetail(rowIndex:indexPath.row)

        }
                
            
            
            self.show(nextViewController, sender: self)
        }
    }
    
}

extension DotAddAppointmentViewController:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            searchByQueryItem(searchText: text)
        }
        searchBar.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        searchBar.showsCancelButton = false
        
        searchBar.endEditing(true)
        // You could also change the position, frame etc of the searchBar
    }
    
    
}

extension DotAddAppointmentViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .currentContext
    }
}
