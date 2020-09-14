//
//  DatePickerController.swift
//  Trackle
//
//  Created by skype on 10/04/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import UIKit

class DatePickerController: UIViewController {
    
    var handler: ((_ selectedDate:Date?,_ indexPath:IndexPath)->Void)?
    var indexPath = IndexPath(row: -1, section: -1)
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    var maxDate: Date?
    var minDate: Date?
    var dateMode: UIDatePicker.Mode?
    var selectedDate: Date?
    
    
    class func datePickerWith(rect: CGRect,sourceView: UIView, presenting: UIViewController,maxDate: Date?,minDate:Date?,selectedDate:Date? = Date(),mode:UIDatePicker.Mode = UIDatePicker.Mode.date, arrowDirection: UIPopoverArrowDirection = .any, handler: @escaping ((_ selectedDate:Date?,_ indexPath:IndexPath)->Void),indexPath:IndexPath = IndexPath(row: -1, section: -1)) {
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePickerController") as! DatePickerController
        controller.indexPath = indexPath
        controller.handler = handler
        controller.modalPresentationStyle = .popover
//        let popOverPresentationController = controller.popoverPresentationController
//        popOverPresentationController?.permittedArrowDirections = arrowDirection
//      //  popOverPresentationController?.delegate = presenting
//        popOverPresentationController?.sourceView = sourceView
//        popOverPresentationController?.sourceRect  = rect
//        controller.maxDate = maxDate
        //using if-let to check for nil and graceful unwrapping of optional
        if let minDateIn = minDate {
            controller.minDate = minDateIn
        }
        
        controller.dateMode = mode
        controller.selectedDate = selectedDate
        controller.preferredContentSize = CGSize(width: 100, height: 100)
        presenting.present(controller, animated: true, completion: nil)
    }
    
    
    class func datePickerWith(maxDate: Date?,minDate:Date?,selectedDate:Date? = Date(),mode:UIDatePicker.Mode = UIDatePicker.Mode.date, arrowDirection: UIPopoverArrowDirection = .any, handler: @escaping ((_ selectedDate:Date?,_ indexPath:IndexPath)->Void),indexPath:IndexPath = IndexPath(row: -1, section: -1)) -> DatePickerController {
        
        let controller = UIStoryboard(name: "Billing", bundle: nil).instantiateViewController(withIdentifier: "DatePickerController") as! DatePickerController
        controller.indexPath = indexPath
        controller.handler = handler
        //        controller.modalPresentationStyle = .popover
        //        let popOverPresentationController = controller.popoverPresentationController
        //        popOverPresentationController?.permittedArrowDirections = arrowDirection
        //        popOverPresentationController?.delegate = presenting
        //        popOverPresentationController?.sourceView = sourceView
        //        popOverPresentationController?.sourceRect  = rect
        controller.maxDate = maxDate
        //using if-let to check for nil and graceful unwrapping of optional
        if let minDateIn = minDate {
            controller.minDate = minDateIn
        }
        
        controller.dateMode = mode
        controller.selectedDate = selectedDate
        //        controller.preferredContentSize = CGSize(width: 300, height: 300)
        return controller
    }
    
    
    
    class func datePickerWithContrlloer(rect: CGRect,sourceView: UIView, presenting: UITableViewController,maxDate: Date?,minDate:Date? = Date(),selectedDate:Date? = Date(), handler: @escaping ((_ selectedDate:Date?,_ indexPath:IndexPath)->Void), indexPath:IndexPath = IndexPath(row: -1, section: -1)) {
        
        let controller = UIStoryboard(name: "Billing", bundle: nil).instantiateViewController(withIdentifier: "DatePickerController") as! DatePickerController
        controller.indexPath = indexPath
        controller.handler = handler
        controller.modalPresentationStyle = .popover
        let popOverPresentationController = controller.popoverPresentationController
        popOverPresentationController?.permittedArrowDirections = .any
       // popOverPresentationController?.delegate = presenting
        popOverPresentationController?.sourceView = sourceView
        popOverPresentationController?.sourceRect  = rect
        controller.maxDate = maxDate
        controller.minDate = minDate
        controller.selectedDate = selectedDate
        controller.preferredContentSize = CGSize(width: 300, height: 300)
        presenting.present(controller, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datePicker.backgroundColor = UIColor.groupTableViewBackground
        self.datePicker.date = selectedDate ?? Date()
        //using if-let to check for nil and graceful unwrapping of optional
        if let maxDa = maxDate {
            self.datePicker.maximumDate = maxDa
        }
        if let minDate = minDate{
            self.datePicker.minimumDate = minDate
            
        }
        if let mode = dateMode{
            self.datePicker.datePickerMode = mode
        }
        
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI()  {
        
        
        doneButton.setTitle("Done", for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        
        headerView.backgroundColor = Theme.accentColor!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  self.datePicker.locale = AppSettings.shared.languageCode.currentLocal() as Locale
       // self.datePicker.calendar = AppSettings.shared.languageCode.currentLocal().object(forKey: NSLocale.Key.calendar) as! Calendar!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func dismissDatePickerVC() {
        self.init().dismiss(animated: true, completion: nil)
        //self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        
    }
    @IBAction func done(_ sender: Any) {
        handler?(self.datePicker.date, indexPath)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
