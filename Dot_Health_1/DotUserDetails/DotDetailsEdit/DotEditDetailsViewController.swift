//
//  DotEditDetailsViewController.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 08/08/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit
import TinyConstraints
import Photos
import SVProgressHUD

protocol ProfilePictureUpdatedProtocol {
    func updateProfilePictur(image:UIImage?)
}


class DotEditDetailsViewController: UIViewController,MultiTableViewDelegate,TableViewDelegate,editTableDelegate,addHabitTableDelegate {
    
@IBOutlet weak var profileDetailsView: UIView!
@IBOutlet weak var detailSections:   UITableView!
@IBOutlet weak var profileImage:   UIImageView!
var myPictureController = UIImagePickerController()
var habitsData = [DotAddHabitModel]()
var profileData:[String:AnyObject]?
var habitIsEdited = false
var profilePictureDelegate: ProfilePictureUpdatedProtocol?
 var profileImag: UIImage?
let data:NSMutableDictionary = ["Personal Details":["Name","Email ","DOB","Address 1","Address 2","City","State","Country","Gender","Phone No","Pincode"],"Habits":["Smoking","Drinking","Exercise"],"Basic Details":["Nationality":"Indian","MemberShip Number":"123456","Primary Communicatio n":"ABCD","Address 1":"DHEF","Address 2":"IJKL","Phone NO":"12345","Insurance Details":"Random Id"]]
let dataSort = [["patient_name","patient_email","patient_dob","patient_address1","patient_address2","patient_city","patient_state","patient_country","patient_gender","patient_mobile","patient_pincode","Additional Details","MemberShip Number","Insurance Details"],["Smoking","Drinking","Exercise"],["Nationality","MemberShip Number","patient_address1","patient_address2","patient_mobile","Insurance Details"]]
    var test1 = [["Name","Email ","DOB","Address 1","Address 2","City","State","Country","Gender","Phone No","Pincode","Additional Details","MemberShip Number","Insurance Details"],["Smoking","Drinking","Exercise"]]
    var test2 = ["Nationality","MemberShip Number","Primary COmmunication","Address 1","Address 2","Phone NO","Insurance Details"]
    let sectionNames = ["Personal Details","Habits"]
    let client = DotConnectionClient()
    let EditSaveButton: CustomButton! = {
        let button = CustomButton(type: .roundedRect)
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Theme.accentColor
        button.tag = 11
        button.layer.cornerRadius = 5
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        profileDetailsView.edgesToSuperview(excluding: .bottom, insets: .left(0) + .right(0) + .top(0),  usingSafeArea: true)
        profileDetailsView.height(200)
        detailSections.topToBottom(of: profileDetailsView,offset: 8)
        detailSections.edgesToSuperview(excluding: .top, insets: .left(8) + .right(8) + .bottom(8),usingSafeArea: true)
        profileImage.cornerRadius = profileImage.frame.width/2
        detailSections.delegate = self
            detailSections.dataSource = self
            detailSections.separatorStyle = .none
        
            detailSections.register(UINib(nibName: "DotDetailsCellView", bundle: nil), forCellReuseIdentifier: "cellId")
            detailSections.register(UINib(nibName: "MultiDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "multiCell")
            detailSections.register(UINib(nibName: "DotAddDocsTableViewCell", bundle: nil), forCellReuseIdentifier: "docs")
        setProfilePicture()
        getHabitDetails()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if profileData?.isEmpty ?? true{
            getUserDetails()
        }
    }
    
    func setProfilePicture () {
        
        if let profilePicture = profileImag {
            DispatchQueue.main.async {
                self.profileImage.image = profilePicture
            }
        }

        
      }
    
    func refreshTable(data: [String : AnyObject]) {
        profileData = data
        detailSections.reloadData()
        NotificationCenter.default.post(name: Notification.Name("ProfileDataUpdated"), object: nil)
    }
    
    func refreshHabitsTable(data: [String:AnyObject]) {
        getHabitDetails()
    }
    
  func afterClickingReturnInTextFields(cell: MultiDetailsTableViewCell) {
            
            print(cell.firstText.text ?? "")
    }
    func afterClickingReturnInTextField(cell: DotDetailsCellView) {
        var arr = data
        ((arr[sectionNames[cell.section]] as? NSDictionary)?.mutableCopy() as? NSMutableDictionary)!.setValue(cell.detailText.text ?? kblankString, forKey: dataSort[cell.section][cell.row])
        print((arr[sectionNames[cell.section]] as? NSDictionary))
    }
    @objc func editSave(_ button: UIButton) {
        
        switch (button.accessibilityIdentifier){
        case "Personal Details":
            let openDetailsObj = DotOpenEditDetails()
            openDetailsObj.userData = profileData ?? [:]
            openDetailsObj.delegate = self
            self.present(openDetailsObj, animated: true, completion: nil)
        case "HabitsEdit":
            if habitIsEdited{
                habitIsEdited = false
            }
            else{
                habitIsEdited = true
            }
            
        case "Habits":
            let openDetailsObj = DotAddHabitController()
            //     openDetailsObj.userData = profileData ?? [:]
            openDetailsObj.delegate = self
            self.present(openDetailsObj, animated: true, completion: nil)
            detailSections.reloadData()
        default:
            print("no data found")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "User Details"
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    func presendPhotoPickerController(isCamera: Bool) {
        
        myPictureController.allowsEditing =  true
        myPictureController.delegate = self
        
        if isCamera == true {
            if(UIImagePickerController .isSourceTypeAvailable(.camera)){
                self.myPictureController.sourceType = .camera
                self.present( self.myPictureController, animated: true, completion: nil)
            } else {
                self.showAlertView("Camera Not Supported", message: "")
                
            }
            
        } else {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                OperationQueue.main.addOperation({() -> Void in
                    self.myPictureController.sourceType = .photoLibrary
                    self.present( self.myPictureController, animated: true) {() -> Void in }
                })
            }
            else {
                self.myPictureController.sourceType = .photoLibrary
                self.present( self.myPictureController, animated: true) {() -> Void in }
            }
        }
        
        
       
        
        
        
//           let alertController = UIAlertController(title: "", message: "Upload profile photo?".localized, preferredStyle: .actionSheet)
//              let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action"), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
//                  alertController.dismiss(animated: true) {() -> Void in }
//              })
//              alertController.addAction(cancelAction)
//              let cameraRollAction = UIAlertAction(title: NSLocalizedString("Open library".localized, comment: "Open library action"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
//
//              })
//              let cameraAction = UIAlertAction(title: "Camera", style: .default){
//                  UIAlertAction in
//                  if(UIImagePickerController .isSourceTypeAvailable(.camera)){
//                       self.myPictureController.sourceType = .camera
//                      self.present( self.myPictureController, animated: true, completion: nil)
//                  } else {
//                      self.showAlertView("Camera Not Supported", message: "")
//
//                  }
//              }
//              alertController.addAction(cameraRollAction)
//              alertController.addAction(cameraAction)
//          present(alertController, animated: true) {() -> Void in }
           
          
//           myPictureController.sourceType = .photoLibrary
//           self.present(myPictureController,animated: false)
       }
    
    func deleteHabitDetails(index:Int){
        
        guard let habitId  = self.habitsData[index].habitId else {
            return()
        }
    // Headers
        let headers = ["Content-Type":"application/json"]
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.custom)
        let api: API = .patientsApi
        let endpoint: Endpoint = api.getPostAPIEndpointForAll(urlString: "\(api.rawValue)\(loginData.user_id ?? 17)/habits/\(habitId)", httpMethod: .delete, queryItems: nil, headers: headers, body: nil)
       
        client.callAPI(with: endpoint.request, modelParser: String.self) { [weak self] result in
            guard let self = self else { return }
            SVProgressHUD.dismiss()
            switch result {
                
            case .success(let model2Result):
                
                     guard let model2Result = model2Result as? [String:AnyObject] else { return }
                           print(model2Result)
                           if model2Result.returnStringForKey(key: "type") == "Success" {
                               do {
                                   let alert = UIAlertController(title: "Success", message: model2Result.returnStringForKey(key: "message"), preferredStyle: UIAlertController.Style.alert)
                                   alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (_) in
                                     //  self.delegate?.refreshTable(data: model2Result)
                                     //  self.dismiss(animated: true, completion: nil)
                                    self.getHabitDetails()
                                       
                                   }))
                                   self.present(alert, animated: true, completion:nil)
                               }
                           } else {
                            if  model2Result.returnStringForKey(key: "title").count > 0, model2Result.returnStringForKey(key: "detail").count > 0 {
                                
                                self.showAlertView(model2Result.returnStringForKey(key: "title"), message:model2Result.returnStringForKey(key: "detail"))
                                
                                
                            } else {
                                self.showAlertView("Alert", message:"Something bad happened.")
                            }
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
       
       @IBAction func takePhotoAction(_ sender: UIButton) {
           PHPhotoLibrary.requestAuthorization({(status) in
               switch status
               {
               case .authorized:
                   DispatchQueue.main.sync {
                    self.presendPhotoPickerController(isCamera: true)
                   }
               case .notDetermined:// not yer set
                   if status == PHAuthorizationStatus.authorized{
                    self.presendPhotoPickerController(isCamera: true)
                   }
               case .restricted:// like parental lock
                   let alert = UIAlertController(title: "Photo Library is restrict", message: "Photo Library is restricted and cannot be accessed", preferredStyle: .alert)
                   let okAction = UIAlertAction(title: "OK", style: .default)
                   alert.addAction(okAction)
                   self.present(alert, animated: true)
               case .denied:// denied last time
                   DispatchQueue.main.async {
                       let alert = UIAlertController(title: "Photo Library is denied", message: "Photo Library was previoulsly denied. Please update your settings if you want to change this", preferredStyle: .alert)
                       let goToSettingAction = UIAlertAction(title: "Go to settings", style: .default){ (action) in
                           
                           let url = URL(string: UIApplication.openSettingsURLString)!
                           UIApplication.shared.open(url, options: [:])
                       }
                       let cancelAction = UIAlertAction(title: "Cancel", style: .default)
                       alert.addAction(goToSettingAction)
                       alert.addAction(cancelAction)
                       self.present(alert, animated: true)
                   }
                   
                   
               @unknown default:
                   return
               }
           })
       }
       
    @IBAction func uploadPhotoAction(_ sender: UIButton) {
        self.presendPhotoPickerController(isCamera: false)
    }
       @IBAction func deletePhotoAction(_ sender: UIButton) {
           let alert = UIAlertController(title: "Alert!", message: "Are you sure you want to delete you profile picture.", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
           alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
               self.profileImage.image = UIImage(named: "user")
               self.profilePictureDelegate?.updateProfilePictur(image: self.profileImage.image)
               self.saveProfilePicture(photoString: "",isDeleted: true)
           }))
           present(alert, animated: true, completion: nil)
       }
     //MARK:API calls
     func getUserDetails(){
         SVProgressHUD.show()
         SVProgressHUD.setDefaultMaskType(.custom)
         let api : API = .patientsApi
         let endpoint: Endpoint = api.getPostAPIEndpointForAll(urlString: "\(api.rawValue)\(loginData.user_id ?? 17)", httpMethod: .get, queryItems: nil, headers: nil, body: nil)
                 client.callAPI(with: endpoint.request, modelParser: String.self) { [weak self] result in
                 guard let self = self else { return }
                 switch result {
                 case .success(let model2Result):
                     SVProgressHUD.dismiss()
                     if let item = model2Result{
                     
                        self.profileData = (item as? [String:AnyObject])!
                        self.detailSections.reloadData()
                         
                     }
                     
                 case .failure(let error):
                     SVProgressHUD.dismiss()
     //                SVProgressHUD.dismiss()
                     print("the error \(error)")
                 }
             }
         }
    
    //MARK:API calls
    func getHabitDetails(){
        self.habitsData.removeAll()
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.custom)
        let api : API = .patientsApi
        let endpoint: Endpoint = api.getPostAPIEndpointForAll(urlString: "\(api.rawValue)\(loginData.user_id ?? 17)/habits", httpMethod: .get, queryItems: nil, headers: nil, body: nil)
        client.callAPI(with: endpoint.request, modelParser: String.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model2Result):
                SVProgressHUD.dismiss()
                
                if let finalResult = model2Result as? Array<Dictionary<String,Any>>
                {
                    for model in finalResult
                    {
                        self.habitsData.append(DotAddHabitModel.init(dict: model))
                    }
                }
                self.detailSections.reloadData()

                
            case .failure(let error):
                SVProgressHUD.dismiss()
                //                SVProgressHUD.dismiss()
                print("the error \(error)")
            }
        }
    }
    
    func deleteConfirmationAlert(index:Int) {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete selected habit?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (_) in
            //  self.delegate?.refreshTable(data: model2Result)
            //  self.dismiss(animated: true, completion: nil)
           
            self.deleteHabitDetails(index: index)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            //  self.delegate?.refreshTable(data: model2Result)
            //  self.dismiss(animated: true, completion: nil)
            
        }))
        self.present(alert, animated: true, completion:nil)
    }
    
    func saveProfilePicture(photoString: String?, isDeleted: Bool = false) {
        
        if var profileData = profileData {
            
            for (key, value) in profileData where (value as? String == kblankString || value as? [String] == [""]) {
                profileData.removeValue(forKey: key)
            }
            profileData.removeValue(forKey: "verified")
            if let imageStr = photoString {
               // profileData["photo"] = imageStr as AnyObject
                profileData.updateValue(imageStr as AnyObject, forKey: "photo")
            }
            guard let body = try? JSONSerialization.data(withJSONObject: profileData) else { return }
            
            
            // Headers
            let headers = ["Content-Type":"application/json"]
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.custom)
            let api: API = .patientsApi
            let endpoint: Endpoint = api.getPostAPIEndpointForAll(urlString: "\(api.rawValue)\(loginData.user_id ?? 17)", httpMethod: .put, queryItems: nil, headers: headers, body: body)
            
            client.callAPI(with: endpoint.request, modelParser: String.self) { [weak self] result in
                guard let self = self else { return }
                SVProgressHUD.dismiss()
                switch result {
                    
                case .success(let model2Result):
                    if let item = model2Result{
                        self.profileData = (item as? [String:AnyObject])!
                        self.detailSections.reloadData()
                        
                    }
                    
                    let message = isDeleted ? "Profile picture deleted successfully." : "Profile picture updated successfully."
                    
                 self.showAlertView(message, message: kblankString)
                    
                    
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

    
}
extension DotEditDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //           return (data.value(forKey: sectionNames[section]) as? NSDictionary)?.count ?? 0
        if sectionNames[section] == "Habits" {
            return habitsData.count
        }
        return dataSort[section].count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sectionNames[indexPath.section] == "Habits"{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "multiCell") as? MultiDetailsTableViewCell else{return UITableViewCell()}
            cell.first.text = habitsData[indexPath.row].habitName
            if let frequency = habitsData[indexPath.row].frequency, let unit = habitsData[indexPath.row].frequencyUnit {
                cell.textString = String(frequency) + "  " +  unit.lowercased()
            }
            cell.tableViewDelegate = self
            cell.row = indexPath.row
            cell.section = indexPath.section
            //   cell.disableEnableViews(check: habitIsEdited)
            cell.setUpYesNo()
            //               if let val = (data[sectionNames[indexPath.section]] as? NSDictionary)?[dataSort[indexPath.section][indexPath.row]] as? String{
            //                   if let iseditable = val.components(separatedBy: "|").first,let frequency = val.components(separatedBy: "|").last{
            //                       switch iseditable{
            //                       case "YES": cell.makeYesEnabled()
            //                       cell.textString = frequency
            //                       default:
            //                           cell.makeNoEnabled()
            //                       }
            //                   }
            //               }
            return cell
        }
        else  if sectionNames[indexPath.section] == "DOCS" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "docs") as? DotAddDocsTableViewCell else{return UITableViewCell()}
            cell.backgroundColor = .clear
            //               cell.addSubview(CardsCollectionView)
            //               CardsCollectionView.edgesToSuperview()
            return cell
        }
            //           else if let arr = (data.value(forKey: sectionNames[indexPath.section]) as? NSArray)?.object(at: indexPath.row) as? NSDictionary{
            //               guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as? DotDetailsCellView else{return UITableViewCell()}
            //               cell.first.text = arr.allKeys.first as? String ?? ""
            //               cell.indicatorButton.setImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
            //               return cell
            //           }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as? DotDetailsCellView else{return UITableViewCell()}
            guard let commCell =  tableView.dequeueReusableCell(withIdentifier: "com") else { return UITableViewCell() }
            cell.first.text = test1[indexPath.section][indexPath.row]
            cell.textView.text = profileData?[dataSort[indexPath.section][indexPath.row]] as? String
            cell.tableViewDelegate = (self)
            cell.section = indexPath.section
            cell.row = indexPath.row
            cell.textView.borderWidth = 0
            
            //               if editLabel == "Edit"{
            //                   cell.textView.borderWidth = 0
            //                   cell.textView.isEditable = false
            //               }
            //               else{
            //                   cell.textView.borderWidth = 1
            //                   cell.textView.isEditable = true
            //                   cell.addDone()
            //               }
            if test1[indexPath.section][indexPath.row] == "Additional Details"{
                return commCell
            }
            else{
                return cell
            }
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        if sectionNames[indexPath.section] == "Habits" && habitIsEdited {
        //            if let  habitID = habitsData[indexPath.row].habitId {
        //                habitIsEdited = false
        //
        //                let openDetailsObj = DotAddHabitController()
        //                //     openDetailsObj.userData = profileData ?? [:]
        //                openDetailsObj.isEditSelected = true
        //                openDetailsObj.selectedHabitID = habitID
        //                openDetailsObj.delegate = self
        //                self.present(openDetailsObj, animated: true, completion: nil)
        //                detailSections.reloadData()
        //            }
        //        }
        
        print("~* make some magic at row: \(indexPath.row) *~")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let frame: CGRect = tableView.frame
        let DoneBut = CustomButton(type: .roundedRect)
        DoneBut.frame =  CGRect(x: frame.width-70, y: 8, width: 60, height: 25)
        
        DoneBut.backgroundColor = Theme.accentColor
        DoneBut.setTitleColor(.white, for: .normal)
        DoneBut.layer.cornerRadius = 5
        DoneBut.accessibilityIdentifier = sectionNames[section]
        //        if sectionNames[section] == "Habits" && habitIsEdited{
        //            DoneBut.setTitle("Save", for: .normal)
        //        }
        //        else{
        //            DoneBut.setTitle("Edit", for: .normal)
        //        }
        if sectionNames[section] == "Habits" {
            DoneBut.setTitle("Add", for: .normal)
        }  else{
            DoneBut.setTitle("Edit", for: .normal)
        }
        
        DoneBut.addTarget(self, action: #selector(editSave(_:)), for: .touchUpInside)
        
        let editBtn = CustomButton(type: .roundedRect)
        editBtn.frame =  CGRect(x: frame.width-145, y: 8, width: 60, height: 25)
        
        editBtn.backgroundColor = Theme.accentColor
        editBtn.setTitleColor(.white, for: .normal)
        editBtn.layer.cornerRadius = 5
        editBtn.accessibilityIdentifier = "HabitsEdit"
        editBtn.setTitle("Edit", for: .normal)
        editBtn.addTarget(self, action: #selector(editSave(_:)), for: .touchUpInside)
        
        
        
        
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 359, height: 55))
        headerView.alpha = 1.0
        headerView.backgroundColor = #colorLiteral(red: 0.6332181692, green: 0.8114793301, blue: 1, alpha: 1)
        headerView.borderWidth = 0
        headerView.borderColor = Theme.accentColor
        headerView.cornerRadius = 5
        headerView.addSubview(DoneBut)
        //        if sectionNames[section] == "Habits" {
        //         headerView.addSubview(editBtn)
        //        }
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: -2, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = sectionNames[section]
        label.font = UIFont.boldSystemFont(ofSize: 14) // my custom font
        label.textColor = UIColor.darkGray // my custom colour
        //
        headerView.addSubview(label)
        
        return headerView
    }
    //   func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    //
    //    let header = view as! UITableViewHeaderFooterView
    //    EditSaveButton.frame =  CGRect(x: tableView.frame.width-80, y: 15, width: 60, height: 30)
    //    let countCheck = header.subviews.filter({$0.tag == 13}).count
    //    EditSaveButton.isHidden = false
    //        if section == 0 {
    //            EditSaveButton.isHidden = false
    //            if !header.subviews.contains(EditSaveButton) && countCheck == 0{
    //                 header.addSubview(EditSaveButton)
    //                print("editsavebutton")
    //            }
    //        }
    //
    //        if let textlabel = header.textLabel {
    //            textlabel.font = UIFont.boldSystemFont(ofSize: 14)
    //        }
    //
    //    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        if sectionNames[indexPath.section] == "Habits"  {
            
            let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                self.deleteConfirmationAlert(index:indexPath.row)
                success(true)
            })
            deleteAction.backgroundColor = .red
            
            let editAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                if let  habitID = self.habitsData[indexPath.row].habitId {
                    // habitIsEdited = false
                    
                    let openDetailsObj = DotAddHabitController()
                    //     openDetailsObj.userData = profileData ?? [:]
                    openDetailsObj.isEditSelected = true
                    openDetailsObj.selectedHabitID = habitID
                    openDetailsObj.delegate = self
                    DispatchQueue.main.async {
                        self.present(openDetailsObj, animated: true, completion: nil)
                        self.detailSections.reloadData()
                    }
                    
                }
                success(true)
            })
            editAction.backgroundColor = Theme.accentColor!
            return UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        }
        return nil
        
        
    }
}
    

extension DotEditDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let Editedimage = info[.editedImage] as? UIImage{
            self.profileImage.image = Editedimage
        }
        else if let selectedImage = info[.originalImage] as? UIImage{
            self.profileImage.image = selectedImage
        }
        profilePictureDelegate?.updateProfilePictur(image: self.profileImage.image)
        let base64string = convertImageTobase64(format: .png, image: self.profileImage.image ?? UIImage())
        
        saveProfilePicture(photoString:base64string)
        
        myPictureController.dismiss(animated: true, completion: nil)
        // dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
