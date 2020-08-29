//
//  DotTimeSlotViewController.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 27/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit
//import <CommonCrypto/CommonDigest.h>
import PlugNPlay
import SVProgressHUD

class DotTimeSlotViewController: UIViewController {

    @IBOutlet weak var doctorDetailView: UIView!
    @IBOutlet weak var doctorImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateTextField: DotTextFieldUtility!
    @IBOutlet weak var timeSlotSegmentedControl: UISegmentedControl!
    @IBOutlet weak var slotsView: UIView!
    
    @IBOutlet weak var noSlotsLabel: UILabel!
    
    @IBOutlet weak var stackViewLegend: UIStackView!
    
    @IBOutlet weak var buttonProceedToPay: DotButtonUtility!
    
    var selectedDocImage = UIImage()
    var selectedName = String()
    var selectedSpec = String()
    var selectedHosPitalName = String()
    var selectedPrice = String()
    var selectedDoctorId: Int?
    var dotAppointmentSlotModel = [DotAppointmentSlotModel]()
    var paymentObject = DotPaymentViewController()
    enum Section :CaseIterable{
        case main
    }
    
    // MARK: DataSource & DataSourceSnapshot typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Section,DotSlotsModel>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section,DotSlotsModel>
    // MARK: dataSource & snapshot
    public var dataSource :DataSource! =  nil
    public var snapshot = DataSourceSnapshot()
    var collectionSuperView = UIView()
    var dashBoardObj = DotDashboardViewController()
    var CardsCollectionView: UICollectionView! = nil
    private let client = DotConnectionClient()
    var identiFierForView:String?
    var isFacilitySelected = false
    var doctorDash = ["2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM"]//make didset
    var selectedTimeDimensionArray = [String]()
    var selectedDate:String?
    var morningSlots = ["08:00 AM - 08:45 Am","09:00 AM - 09:45 AM","10:00 AM - 10:45 AM","11:00 AM - 11:45 AM","12:00 AM - 12:45 AM"]
    var noonSlots = ["01:00 PM - 01:45 PM","02:00 PM - 02:45 PM","03:00 PM - 03:45 PM","04:00 PM - 04:45 PM","05:00 PM - 05:45 PM"]
    var eveningSlots = ["06:00 PM - 06:45 PM","07:00 PM - 07:45 PM","08:00 PM - 08:45 PM","09:00 PM - 09:45 PM"]
    var green = [3,6,9,11]
    var red = [4,12,13,14]

    var dummyModel = [DotSlotsModel]()
    weak var delegate:saveAddedSlots?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select a time slot"
        self.dateTextField.delegate = self
        self.dateTextField.text = UtilityFunctions.getTodayDate()
        if isFacilitySelected {
            self.noSlotsLabel.isHidden = true
            self.slotsView.isHidden = true
            self.buttonProceedToPay.isHidden = false
            self.stackViewLegend.isHidden = true
        }
        else {
            fetchTimeSlotForDoctor(selectedDate: UtilityFunctions.getTodayDateFormat())

        }
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateSlotDataForSelectedDate(notification:)), name: Notification.Name("DateSelected"), object: nil)

         
      //  createDummyData(selectedSeg:1)
    }
    @objc func updateSlotDataForSelectedDate(notification: Notification) {
        
        if let date = self.dateTextField.text?.stringToDate() {
            fetchTimeSlotForDoctor(selectedDate: UtilityFunctions.getTFormattedDate(date:date))
        }
    }

    
    @IBAction func filterSlots(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
       // createDummyData(selectedSeg: sender.selectedSegmentIndex)
        bindData()

    }
    
    func fetchTimeSlotForDoctor(selectedDate:String) {
        
        let queryItem = [URLQueryItem(name: "slotDate", value:selectedDate)]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.custom)
        guard let doctorId = selectedDoctorId else {
            SVProgressHUD.dismiss()
            self.showHideDataForSlots(isHidden: true)
            
            return
        }
        
        let api : API = .api1
        let endpoint: Endpoint = api.getPostAPIEndpointForAppointments(urlString: "\(api.rawValue)doctors/\(String(doctorId))/slots", queryItems: queryItem, headers: nil, body: nil)
        client.callAPI(with: endpoint.request, modelParser: [DotAppointmentSlotModel].self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model2Result):
                SVProgressHUD.dismiss()
                if let model = model2Result as? [DotAppointmentSlotModel], model.count > 0 {
                    self.showHideDataForSlots(isHidden: false)
                    self.dotAppointmentSlotModel.append(contentsOf: model)
                    self.selectedDate = self.dotAppointmentSlotModel.first?.slot_date
                    self.computeSlotsData()
                }
                else{
                    self.showHideDataForSlots(isHidden:true)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                print("the error \(error)")
                if case let APIError.errorAllResponse(description, message, _) = error {
                    self.showAlertView(message, message: description)
                }
            }
        }
    }
    
    func showHideDataForSlots(isHidden:Bool) {
        self.noSlotsLabel.isHidden = !isHidden
        self.slotsView.isHidden = isHidden
        self.buttonProceedToPay.isHidden = isHidden
        self.stackViewLegend.isHidden = isHidden
    }
        
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func computeSlotsData() {
        self.dateTextField.text = self.selectedDate
        for model in self.dotAppointmentSlotModel {
            if let startTime = model.start_time , let endTime = model.end_time, let date = model.slot_date {
                let slot = startTime + " - " + endTime
                if date == selectedDate {
                 selectedTimeDimensionArray.append(slot)
                }
            }
        }
        configureCollectionView()
        configureCollectionViewDataSource()
        bindData()
  }
        
    func setUpFacilityDetail(rowIndex: Int){
        self.doctorImageView.image = UIImage(named: "hospitalImage")
        self.nameLabel.text = MyData.facilityModelArray[rowIndex].name
        self.specialityLabel.text = MyData.facilityModelArray[rowIndex].country
        self.hospitalNameLabel.text = MyData.facilityModelArray[rowIndex].state
//        if let fees = MyData.facilityModelArray[rowIndex].fees {
//            self.priceLabel.text = "$ \(fees)"
//            self.priceLabel.isHidden = false
//        }
//        else {
            self.priceLabel.isHidden = true
//        }
//        self.priceLabel.textColor = #colorLiteral(red: 0, green: 0.6795158386, blue: 0, alpha: 1)
    }

    
    func setUpDoctorDetail(rowIndex: Int){
        self.doctorImageView.image = UIImage(named: "DoctorImage")
        self.nameLabel.text = MyData.doctorModelArray[rowIndex].name
        self.specialityLabel.text = MyData.doctorModelArray[rowIndex].country
        self.hospitalNameLabel.text = MyData.doctorModelArray[rowIndex].state
        if let fees = MyData.doctorModelArray[rowIndex].fees {
            self.priceLabel.text = "$ \(fees)"
            self.priceLabel.isHidden = false
        }
        else {
            self.priceLabel.isHidden = true
        }
        self.priceLabel.textColor = #colorLiteral(red: 0, green: 0.6795158386, blue: 0, alpha: 1)
    }
 
    @IBAction func optionButtonSelected(_ sender: UIButton) {
       sender.createSelectedOptionButton()
    
    }
    @objc func cancelButtonAcction(){
           dateTextField.resignFirstResponder()
         //  endDateTextField.resignFirstResponder()
       }
    
    @IBAction func proceedToPayAction(_ sender: UIButton) {
      let storyBoard : UIStoryboard = UIStoryboard(name: String(describing: DotPaymentViewController.self) , bundle:nil)
                 let nextViewController = storyBoard.instantiateInitialViewController() as! DotPaymentViewController
                 
                 let _ = nextViewController.view
        nextViewController.doctorImageView.image =  self.doctorImageView.image
        nextViewController.doctorNameLabel.text = self.nameLabel.text
        nextViewController.doctorTypeLabel.text =  self.specialityLabel.text
        nextViewController.doctorAddressLabel.text = self.hospitalNameLabel.text
        nextViewController.priceLabel.text = self.priceLabel.text
        nextViewController.priceLabel.textColor =  self.priceLabel.textColor
                 self.show(nextViewController, sender: self)
    }
    
}
extension DotTimeSlotViewController:UITextFieldDelegate{
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        textField.openDatePicker(modeType: .date)
//        return true
//
//    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
       textField.openDatePicker(modeType: .date,pastDate: false)
      // showPopup(calenderPopover, sourceView: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
