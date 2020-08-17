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
    var selectedDocImage = UIImage()
    var selectedName = String()
    var selectedSpec = String()
    var selectedHosPitalName = String()
    var selectedPrice = String()
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
    var identiFierForView:String?
    var doctorDash = ["2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM","2:00 PM - 2:45 PM"]//make didset
    var green = [3,6,9,11]
    var red = [4,12,13,14]

    var dummyModel = [DotSlotsModel]()
    weak var delegate:saveAddedSlots?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select a time slot"
        self.dateTextField.delegate = self
        self.dateTextField.text = UtilityFunctions.getTodayDate()
         configureCollectionView()
        configureCollectionViewDataSource()
        createDummyData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setUpDoctorDetail(rowIndex: Int){
        self.doctorImageView.image = UIImage(named: "DoctorImage")
        self.nameLabel.text = MyData.doctorModelArray[rowIndex].name
        self.specialityLabel.text = MyData.doctorModelArray[rowIndex].country
        self.hospitalNameLabel.text = MyData.doctorModelArray[rowIndex].state
        self.priceLabel.text = "$100"//MyData.doctorModelArray[rowIndex].gender
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        textField.openDatePicker(modeType: .date)
       
      // showPopup(calenderPopover, sourceView: textField)
    }
}
