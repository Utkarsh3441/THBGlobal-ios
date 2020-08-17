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
    var selectedAilment : [[String:Any]] = []
    @IBOutlet weak var selectedAilmentLabel: UILabel!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    var selectedIndexPath: IndexPath = IndexPath()
    var screenName : String = kblankString
    let controller = UIStoryboard(name: "DotMedicines", bundle: nil).instantiateInitialViewController() as? DotMedicinesController
     private let client = DotConnectionClient()
    var ailments = [ailment]()
    var services = [service]()
    var doctorData = [DoctorModel]()
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
        }
        else{
            getAilments()
            getServices()
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
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let destination = segue.destination as? DotAilmentViewController  {
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
           }
        
        }
        
            if (segue.identifier == "timeSlotView") &&  self.selectedIndexPath.count > 0{
                let viewController = segue.destination as? DotTimeSlotViewController
                viewController?.selectedName = MyData.doctorModelArray[ self.selectedIndexPath.row].name
                viewController?.selectedSpec = MyData.doctorModelArray[ self.selectedIndexPath.row].country
                viewController?.selectedHosPitalName = MyData.doctorModelArray[ self.selectedIndexPath.row].state
                viewController?.selectedPrice = "$100"//MyData.doctorModelArray[ self.selectedIndexPath.row].gender
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
        case "Facility":
            sender.createSelectedOptionButton()
            ailmentButton.setTitle("Services", for: .normal)
            self.doctorButton.createOptionButton()
        case "Services":
             sender.createSelectedOptionButton()
        default:
            print("Wrong button")
        }
    }
    

    @IBAction func searchAction(_ sender: UIButton) {
        
       print(selectedAilment)
        if selectedAilment.count > 0{
             searchItemsForQuery(searchItem: selectedAilment)
        }
      
    }
    
}
//MARK:API CAlls
extension DotAddAppointmentViewController{
    func getMedication(){
        SVProgressHUD.show()
        let api: API = .api1
        let endpoint: Endpoint = api.getPostAPIEndpointForMedication(urlString: "\(api.rawValue)patients/13/medications", queryItems: nil, headers: nil, body: nil)
        client.callAPI(with: endpoint.request, modelParser: [MyMedicineModel].self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model2Result):
                SVProgressHUD.dismiss()
                if let model = model2Result as? [MyMedicineModel]{
                    MyData.myMedicineModelArray = model
                    print("Fetched doctor:",MyData.myMedicineModelArray)
                    MyMedicationFunctions.readMyMedicine(complition: {[unowned self] in
                        
                        self.doctorListTableView.reloadData()
                        
                    })
                }
                else{
                    print("error occured")
                    SVProgressHUD.dismiss()
                }
            case .failure(let error):
                
                SVProgressHUD.dismiss()
                print("the error \(error)")
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
                print("the error \(error)")
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
            
            print("the error \(error)")
        }
    }
}
    func searchItemsForQuery(searchItem:[[String:Any]]){
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.custom)
        // Query item for doc
        var queryItem = [URLQueryItem]()
      //  var urlString = ""
        if let item = searchItem.first?["name"] as? String,let id = searchItem.first?["id"] as? Int{
            if ailments.contains(where: {$0.ailment == item}){
                 queryItem = [ URLQueryItem(name: "ailmentId", value:"\(id)"), URLQueryItem(name: "city", value: "Bangalore")]
                urlString = "doctors"
                
            }
            else if services.contains(where: {$0.service == item}){
                queryItem = [ URLQueryItem(name: "serviceId", value: "\(id)"), URLQueryItem(name: "city", value: "Delhi")]
                urlString = "facilities"
            }
        }
        
          // Query item for facility
        let api : API = .api1
        let endpoint: Endpoint = api.getPostAPIEndpointForAppointments(urlString: "\(api.rawValue)\(urlString)", queryItems: nil, headers: nil, body: nil)
        switch urlString{
        case "doctors":
            client.callAPI(with: endpoint.request, modelParser: [DoctorModel].self) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let model2Result):
                            SVProgressHUD.dismiss()
                            if let model = model2Result as? [DoctorModel]{
                                MyData.doctorModelArray = model
                                print("Fetched doctor:",MyData.doctorModelArray)
                                doctorFunctions.readDoctors(complition: {[unowned self] in
                                                  
                                                  self.doctorListTableView.reloadData()
                                                 
                                              })
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
                            print("the error \(error)")
                        }
                    }
        case "facilities":
            client.callAPI(with: endpoint.request, modelParser: [FacilityModel].self) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let model2Result):
                            SVProgressHUD.dismiss()
                            if let model = model2Result as? [FacilityModel]{
                                MyData.facilityModelArray = model
                                print("Facility data :",MyData.facilityModelArray)
                                // write here to populate facility data in table
                                facilityFunctions.readFacilities(complition: {[unowned self] in
                                    
                                    self.doctorListTableView.reloadData()
                                    
                                })
                            }
                            else{
                                print("error occured")
                            }
                        case .failure(let error):
                            SVProgressHUD.dismiss()
                            print("the error \(error)")
                        }
                    }
        default:
            print("no data found")
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
            let sheetController = SheetViewController(controller: controller ?? UIViewController(), sizes: [.fixed(250), .halfScreen])
                   
                   
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
            self.present(sheetController, animated: false, completion: nil)
        }
        else{
            let storyBoard : UIStoryboard = UIStoryboard(name: String(describing: DotTimeSlotViewController.self) , bundle:nil)
            let nextViewController = storyBoard.instantiateInitialViewController() as! DotTimeSlotViewController
            
            let _ = nextViewController.view
            nextViewController.setUpDoctorDetail(rowIndex:indexPath.row)
            self.show(nextViewController, sender: self)
        }
        
        
    }
    
}
