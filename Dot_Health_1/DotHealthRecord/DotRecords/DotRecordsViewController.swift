//
//  DotRecordsViewController.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 01/08/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit
import LBTATools
import MobileCoreServices
import Photos
import SVProgressHUD
class CellClass: UITableViewCell {
    
}
class DotRecordsViewController: LBTAFormController {
    let transparentView = UIView()
      let tableView = UITableView()
      var docTextField = UITextField()
      var selectedButton = UIButton()
     var headers = HeaderValues()
    var httpBody: Data?
     let client = DotConnectionClient()
      // MARK: DataSource & DataSourceSnapshot typealias
      typealias DataSource = UICollectionViewDiffableDataSource<Section,record>
      typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section,record>
      // MARK: dataSource & snapshot
       var dataSource :DataSource! =  nil
       var snapshot = DataSourceSnapshot()
      var collectionSuperView = UIView()
      var documentController:UIDocumentInteractionController!
      var CardsCollectionView: UICollectionView! = nil
      var identiFierForView:String?
      var doctorDash = ["2:00 PM - 2:45 PM",""]//make didset
      var green = [3,6,9,11]
      var red = [4,12,13,14]
      var dummyModel = [AdddocumentsModel]()
      var recordsDataArray = [record]()
    var addedRecords = [record]()
    var deletedRecords = [record]()
      var docIndex = 0
      let addDocumentsLimiter = 10
      var dataItems = [String]()
    let signUpButton = UIButton(title: "Appointment ID                                  ", titleColor: .white, font: .boldSystemFont(ofSize: 16), backgroundColor: Theme.gradientColorDark!, target: self, action: nil)
    let uploadButton = UIButton(title: "Upload Files", titleColor: .white, font: .boldSystemFont(ofSize: 16), backgroundColor: Theme.accentColor!, target: self, action: #selector(uploadFile))
    var buttonsArr = ["Upload Picture","Upload Documents","Share Cloud Link"]
    var imgArr = [#imageLiteral(resourceName: "camera1") ,#imageLiteral(resourceName: "gallery") ,#imageLiteral(resourceName: "cloud1") ]
    @objc fileprivate func uploadFile() {
//        dismiss(animated: true)
        if !addedRecords.isEmpty {
            
            if let text = docTextField.text, text.count > 0 {
                self.upload(files: self.addedRecords, toURL: nil, withHttpMethod: .post){
                    [weak self] (x,y) in
                    print("\(x) and \(y ?? [""])")
                }
            } else {
                self.showAlertView("Please provide value for document type", message: kblankString)
            }
        }
        else{
            self.showAlertView("No Files To Upload", message: kblankString)
        }
    }

    var docsButton = UIButton(type: .custom)
    
    var cameraButton = UIButton(type: .custom)
//    let githubButton = UIButton(image: #imageLiteral(resourceName: "github_circle").withRenderingMode(.alwaysOriginal))
    let downButton:UIButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Records"
        
        docTextField.delegate = self
        scrollView.alwaysBounceVertical = true
        formContainerStackView.axis = .vertical
        formContainerStackView.spacing = 15
        formContainerStackView.layoutMargins = .init(top: 20, left: 24, bottom: 16, right: 24)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        configureCollectionView()
        configureCollectionViewDataSource()
        createDummyData()
        let separator1 = UIView()
        let separator2 = UIView()
        let collectionViewContainer = UIView()
        view.backgroundColor = .white
        if #available(iOS 13.0, *) {
            downButton.setImage(UIImage(systemName:"chevron.down"), for: .normal)
        } else {
            // Fallback on earlier versions
             downButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }
         downButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        downButton.addTarget(self, action: #selector(self.selectType), for: .touchUpInside)
        downButton.accessibilityIdentifier = "category"
    
        (0...0).forEach { (_) in
            let tf = IndentedTextField(placeholder: "Select Document Type", padding: 12, cornerRadius: 5, backgroundColor: .white)
            tf.constrainHeight(40)
            tf.rightView = downButton
            tf.rightViewMode = .always
            tf.layer.borderWidth = 1
            tf.delegate = self
            tf.layer.borderColor = UIColor.darkGray.cgColor
            docTextField = tf
            formContainerStackView.addArrangedSubview(tf)
        }
        
        let buttonsStack = UIStackView()
        (0...2).forEach { (i) in
            let buttons1 = UIButton(backgroundColor: Theme.accentColor!)
            
             let nameLabel = UILabel(text: buttonsArr[i], font: .boldSystemFont(ofSize: 14), numberOfLines: 0)
            buttons1.setImage(imgArr[i].withRenderingMode(.alwaysOriginal), for: .normal)
            
            nameLabel.textAlignment = .center
             buttons1.layer.cornerRadius = 35
            buttons1.constrainWidth(70)
            buttons1.constrainHeight(70)
            let stack1 = UIStackView(arrangedSubviews: [buttons1,nameLabel])
            stack1.constrainHeight(60)
            stack1.axis = .vertical
            stack1.alignment = .center
            switch buttonsArr[i]{
            case "Upload Picture" : cameraButton = buttons1
            cameraButton.addTarget(self, action: #selector(self.openCamera), for: .touchUpInside)
            case "Upload Documents": docsButton = buttons1
            docsButton.addTarget(self, action: #selector(self.openDocs), for: .touchUpInside)
            default:
                print("not buttons")
            }
            buttonsStack.addArrangedSubview(stack1)
            buttonsStack.spacing = 8
            buttonsStack.constrainHeight(110)
            buttonsStack.distribution = .fillEqually
        }
        formContainerStackView.addArrangedSubview(buttonsStack)
        formContainerStackView.addArrangedSubview(separator1)
        separator1.backgroundColor = .black
        separator1.constrainHeight(1)
        formContainerStackView.addArrangedSubview(signUpButton)
        //appointmentSetup
        signUpButton.constrainHeight(50)
        signUpButton.semanticContentAttribute = .forceRightToLeft
        signUpButton.setImage(UIImage(systemName:"chevron.down"), for: .normal)
        signUpButton.tintColor = Theme.tintcolor
        signUpButton.layer.cornerRadius = 10
        signUpButton.addTarget(self, action: #selector(self.selectAppointment), for: .touchUpInside)
        //end
        formContainerStackView.addArrangedSubview(separator2)
        separator2.backgroundColor = .black
        separator2.constrainHeight(1)
        formContainerStackView.addArrangedSubview(collectionViewContainer)
        collectionViewContainer.backgroundColor = Theme.gradientColorLight?.withAlphaComponent(0.4)
        collectionViewContainer.constrainHeight(300)
        collectionViewContainer.layer.cornerRadius = 10
        collectionViewContainer.addSubview(CardsCollectionView)
        CardsCollectionView.edgesToSuperview()
        formContainerStackView.addArrangedSubview(uploadButton)
        uploadButton.constrainHeight(50)
        uploadButton.layer.cornerRadius = 10
        loadFiles()
//        formContainerStackView.addArrangedSubview(stack)
//        stack.constrainHeight(100)
//        stack.spacing = 8
//        buttonsStackView.distribution = .fillEqually
    }
    @objc func openCamera(_ sender: UIButton) {
        if addedRecords.isEmpty{
            let photos = PHPhotoLibrary.authorizationStatus()
            if photos == .notDetermined {
                PHPhotoLibrary.requestAuthorization({status in
                    if status == .authorized{
                        print("OKAY")
                    } else {
                        print("NOTOKAY")
                    }
                })
            }
            checkLibrary()
            checkPermission()
        }
        else{
            self.showAlertView("Cannot Add items", message: "Kindly Save/Delete the existing item to continue")
        }
    }
    @objc func openDocs(_ sender: UIButton) {
        if addedRecords.isEmpty{
         openDocumentPicker()
        }else{
            self.showAlertView("Cannot Add items", message: "Kindly Save/Delete the existing item to continue")
        }
    }
    @objc func selectAppointment(_ sender: UIButton) {
            dataItems = ["16", "17", "56","23"]
            selectedButton = sender
            addTransparentView(frames: signUpButton.frame)
//        guard let imageFileURL = URL(string: dummyModel[1].cardTitle ?? "") else {return}
//
//        upload(files: [FileInfo(withFileURL: imageFileURL, filename: "sampleImage.PNG", name: "uploadedFile", mimetype: "image/png")], toURL: imageFileURL, withHttpMethod: .post){
//            [weak self] (x,y) in
//
//        }
//        uploads(files: [FileInfo(withFileURL: imageFileURL, filename: "sampleImage.PNG", name: "uploadedFile", mimetype: "image/png")], toURL: imageFileURL, withHttpMethod: .post){
//            [weak self] (x,y) in
//
//        }
        }
   
    @objc func selectType(_ sender: UIButton) {
               dataItems = ["Blood Report", "Xray", "Prescription","CT Scan"]
               selectedButton = sender
               addTransparentView(frames: docTextField.frame)
           }
    func addTransparentView(frames: CGRect) {
        let window = view.window
           transparentView.frame = window?.frame ?? self.view.frame
           self.view.addSubview(transparentView)
           
           tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
           self.view.addSubview(tableView)
           tableView.layer.cornerRadius = 10
           
           transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
           tableView.reloadData()
           let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
           transparentView.addGestureRecognizer(tapgesture)
           transparentView.alpha = 0
           UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
               self.transparentView.alpha = 0.5
               self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataItems.count * 50))
           }, completion: nil)
       }
       
       @objc func removeTransparentView() {
           let frames = selectedButton.frame
           UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
               self.transparentView.alpha = 0
               self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
           }, completion: nil)
       }

}
extension DotRecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataItems[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedButton.accessibilityIdentifier == "category"{
            docTextField.text = dataItems[indexPath.row]
        }
        else{
            selectedButton.setTitle("Appointment ID: \(dataItems[indexPath.row])", for: .normal)
        }
        
        removeTransparentView()
    }
}

extension DotRecordsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
