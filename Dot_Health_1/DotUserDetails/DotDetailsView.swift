//
//  DotDetailsView.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 09/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit
import TinyConstraints
import QuickLook
import SVProgressHUD
import Kingfisher

enum Section :CaseIterable{
    case main
}
class DotDetailsView: UIViewController,TableViewDelegate, MultiTableViewDelegate{
    
    @IBOutlet weak var profileDataView: UIView!
//    let data:NSMutableDictionary = ["Basic Details":["Nationality","Religion","MemberShip Number","Primary Address","Communication","Insurance Details","Emirates ID"], "Habits":["Smoking","Drinking","Exercise"],"DOCS":[""]]
    let data:NSMutableDictionary = ["Basic Details":["Nationality":"Indian","MemberShip Number":"123456","Primary Address":"ABCD","Address 1":"DHEF","Address 2":"IJKL","Insurance Details":"Random Id",], "Habits":["Smoking":"YES|10","Drinking":"NO","Exercise":"YES|10"]]
    let dataSort = [["Nationality","MemberShip Number","Primary Address","Address 1","Address 2","Insurance Details"],["Smoking","Drinking","Exercise"]]
    let sectionNames = ["Basic Details","Habits"]
    var expandableRows = [Any]()
    var isExpanded :Bool = false
    var expandedheader = ""
    let client = DotConnectionClient()
    var patientDetails:registerModel?
    var editPatientDetails:[String:AnyObject]?
    @IBOutlet weak var profileImage: AnimatedImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var saveHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableviewBottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var mainView: UIView!
    var constTableView = UITableView()
    var constView = UIView()
    @IBOutlet weak var detailsShow: UIButton!
    @IBOutlet weak var LabelStackView: UIStackView!
    var documentController:UIDocumentInteractionController!
    var editLabel = "Edit"
    weak var delegate:setViewControllerAutomatically?
    
    // MARK: DataSource & DataSourceSnapshot typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Section,AdddocumentsModel>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section,AdddocumentsModel>
    // MARK: dataSource & snapshot
    private var dataSource :DataSource! =  nil
    private var snapshot = DataSourceSnapshot()
    var collectionSuperView = UIView()
    
    var CardsCollectionView: UICollectionView! = nil
    var identiFierForView:String?
    var doctorDash = ["2:00 PM - 2:45 PM",""]//make didset
    var green = [3,6,9,11]
    var red = [4,12,13,14]
    var dummyModel = [AdddocumentsModel]()
    var docIndex = 0
    let addDocumentsLimiter = 10
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
        print("i am here")
        getPatientDetails()
        Bundle.main.loadNibNamed("DotDetailsView", owner: self, options: nil)
        profileDataView.edgesToSuperview(usingSafeArea: true)
        profileDataView.height(self.view.frame.height/2 - 250)
        
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
    
        table.register(UINib(nibName: "DotDetailsCellView", bundle: nil), forCellReuseIdentifier: "cellId")
        table.register(UINib(nibName: "MultiDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "multiCell")
        table.register(UINib(nibName: "DotAddDocsTableViewCell", bundle: nil), forCellReuseIdentifier: "docs")
        constTableView = table
        constView = mainView
        configureCollectionView()
        configureCollectionViewDataSource()
        createDummyData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadProfileData(notification:)), name: Notification.Name("ProfileDataUpdated"), object: nil)

    }
    @objc func reloadProfileData(notification: Notification) {
        
        getPatientDetails()
        
     }
    
    func setDetails(){
        LabelStackView.arrangedSubviews.forEach { (lable) in
            var patientId = ""
            if let id = patientDetails?.patient_id {
                patientId = String(id)
            }
                        
            switch lable.tag{
            case 1 : (lable as? UILabel)?.attributedText = NSAttributedString().createAttributedString(first: patientDetails?.patient_name ?? kblankString, second: "                               \(patientId)",fColor: Theme.accentColor ?? #colorLiteral(red: 0.2069825828, green: 0.7254605889, blue: 1, alpha: 1), sColor: Theme.gradientColorLight!, fBold:true,sBold:true,fSize: 14.0,sSize: 14.0)
            case 2 : (lable as? UILabel)?.attributedText = NSAttributedString().createAttributedString(first: "DOB: ", second: patientDetails?.patient_dob ?? kblankString, fColor:Theme.accentColor ?? #colorLiteral(red: 0.2069825828, green: 0.7254605889, blue: 1, alpha: 1), sColor: .black,fBold:true,sBold:false,fSize: 14.0,sSize: 14.0)
            case 3 : (lable as? UILabel)?.attributedText = NSAttributedString().createAttributedString(first: "Phone no: ", second: patientDetails?.patient_mobile ?? kblankString, fColor: Theme.accentColor ?? #colorLiteral(red: 0.2069825828, green: 0.7254605889, blue: 1, alpha: 1), sColor: .black,fBold:true,sBold:false,fSize: 14.0,sSize: 14.0)
            case 4 : (lable as? UILabel)?.attributedText = NSAttributedString().createAttributedString(first: "Email: ", second: patientDetails?.patient_email ?? kblankString, fColor: Theme.accentColor ?? #colorLiteral(red: 0.2069825828, green: 0.7254605889, blue: 1, alpha: 1), sColor: .black,fBold:true,sBold:false,fSize: 14.0,sSize: 14.0)
            case 5 : (lable as? UILabel)?.attributedText = NSAttributedString().createAttributedString(first: "City: ", second: patientDetails?.patient_city ?? kblankString, fColor: Theme.accentColor ?? #colorLiteral(red: 0.2069825828, green: 0.7254605889, blue: 1, alpha: 1), sColor: .black,fBold:true,sBold:false,fSize: 14.0,sSize: 14.0)
            case 6 : (lable as? UILabel)?.attributedText = NSAttributedString().createAttributedString(first: "State: ", second: patientDetails?.patient_state ?? kblankString, fColor: Theme.accentColor ?? #colorLiteral(red: 0.2069825828, green: 0.7254605889, blue: 1, alpha: 1), sColor: .black,fBold:true,sBold:false,fSize: 14.0,sSize: 14.0)
            case 7 : print("3")
            case 8 : print("3")
            default: break
                
            }
            
        }
    }
    @IBAction func ShowDetails(_ sender: Any) {
        table = constTableView
        mainView = constView
//        if detailsShow.titleLabel?.text != " Back"{
//            detailsShow.setTitle(" Back", for: .normal)
//            detailsShow.setImage(UIImage(systemName: "arrow.left")?.withTintColor(Theme.accentColor ?? UIColor.systemBlue), for: .normal)
//            delegate?.addChildView(mainView,back: false)
//            table.edgesToSuperview()
//        }
//        else{
//            detailsShow.setTitle("Details", for: .normal)
//            detailsShow.setImage(UIImage(), for: .normal)
//            delegate?.addChildView(mainView,back: true)
//
//        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "DotDetailsStoryboard", bundle:nil)
        let nextViewController = storyBoard.instantiateInitialViewController() as! DotEditDetailsViewController
        //nextViewController.itemName = "Mtalk to THB"
        nextViewController.profileImag = profileImage.image
        nextViewController.profileData = editPatientDetails
        nextViewController.profilePictureDelegate = self
        let _ = nextViewController.view
        
        delegate?.addChildViewController(nextViewController, back: false)
    }
    @IBAction func saveAction(_ sender: Any) {
        
    }
    @objc func editSave(_ button: UIButton){
        switch EditSaveButton.currentTitle! {
        case "Edit":
            
            
            self.EditSaveButton.setTitle("Save", for: .normal)
            editLabel = "Save"
            
            self.table.reloadData()
            
        default:
            
            
            self.EditSaveButton.setTitle("Edit", for: .normal)
            editLabel = "Edit"
            
            self.table.reloadData()
        }
    }
    func afterClickingReturnInTextField(cell: DotDetailsCellView) {
        var arr = data
        ((arr[sectionNames[cell.section]] as? NSDictionary)?.mutableCopy() as? NSMutableDictionary)!.setValue(cell.detailText.text ?? kblankString, forKey: dataSort[cell.section][cell.row])
        print((arr[sectionNames[cell.section]] as? NSDictionary))
    }
    func afterClickingReturnInTextFields(cell: MultiDetailsTableViewCell) {
           
           print(cell.firstText.text ?? "")
       }
    func customStringFormatting( str: String,no:Int) -> String {
        var newStr = str
        for _ in 0...no{newStr += " " }
        return newStr
    }
    @objc func buttonClicked(_ sender:UIButton){
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

        UIView.animate(withDuration: 0.2,
                                      delay: 0,
                                      usingSpringWithDamping: CGFloat(0.20),
                                      initialSpringVelocity: CGFloat(6.0),
                                      options: UIView.AnimationOptions.allowUserInteraction,
                                      animations: {
                                       sender.transform = CGAffineTransform.identity
               },
                                      completion: { Void in()  }
           )
    }
//MARK:API calls
    func getPatientDetails(){
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
                        do {
                            let data = try JSONSerialization.data(withJSONObject: item)
                            self.patientDetails = try JSONDecoder().decode(registerModel.self, from: data)
                            self.setDetails()
                            self.setProfilePicture(str: item["photo"] as? String)
                            MyData.patientDetails = self.patientDetails
                            self.editPatientDetails = (item as? [String:AnyObject])!
                        } catch  {
                            print(error.localizedDescription)
                        }
                        
                    }
                    
                case .failure(let error):
                    SVProgressHUD.dismiss()
    //                SVProgressHUD.dismiss()
                    print("the error \(error)")
                }
            }
        }
    
    func setProfilePicture (str: String?) {
        
        var image: UIImage? = nil
        
        if let encodedString = str , let imageFetch = self.base64ToImage(base64String: encodedString.padding(toLength: ((encodedString.count+3)/4)*4, withPad: "=", startingAt: 0))
        {
            image = imageFetch
            DispatchQueue.main.async {
                self.profileImage.image = image
            }
        }
    }
        

    func base64ToImage(base64String: String?) -> UIImage?{
        if (base64String?.isEmpty)! {
            return UIImage(named: "user")
        }else {
            // Separation part is optional, depends on your Base64String !
            let tempImage = base64String?.components(separatedBy: ",")
            if let data = tempImage?.first {
                let dataDecoded : Data = Data(base64Encoded: data, options: .ignoreUnknownCharacters)!
                let decodedimage = UIImage(data: dataDecoded)
                return decodedimage
            }
        }
        return nil
    }
   
    
}
protocol setViewAutomatically : class{
    func addChildView(_ view: UIView, back:Bool)
}
extension DotDetailsView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (data.value(forKey: sectionNames[section]) as? NSDictionary)?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sectionNames[indexPath.section] == "Habits"{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "multiCell") as? MultiDetailsTableViewCell else{return UITableViewCell()}
            cell.first.text = dataSort[indexPath.section][indexPath.row]
            cell.tableViewDelegate = self
            cell.row = indexPath.row
            cell.section = indexPath.section
            if let val = (data[sectionNames[indexPath.section]] as? NSDictionary)?[dataSort[indexPath.section][indexPath.row]] as? String{
                if let iseditable = val.components(separatedBy: "|").first,let frequency = val.components(separatedBy: "|").last{
                    switch iseditable{
                    case "YES": cell.makeYesEnabled()
                    cell.textString = frequency
                    default:
                        cell.makeNoEnabled()
                    }
                }
            }
            return cell
        }
        else  if sectionNames[indexPath.section] == "DOCS" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "docs") as? DotAddDocsTableViewCell else{return UITableViewCell()}
            cell.backgroundColor = .clear
            cell.addSubview(CardsCollectionView)
            CardsCollectionView.edgesToSuperview()
            return cell
        }
        else if let arr = (data.value(forKey: sectionNames[indexPath.section]) as? NSArray)?.object(at: indexPath.row) as? NSDictionary{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as? DotDetailsCellView else{return UITableViewCell()}
            cell.first.text = arr.allKeys.first as? String ?? ""
            cell.indicatorButton.setImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as? DotDetailsCellView else{return UITableViewCell()}
            cell.first.text = dataSort[indexPath.section][indexPath.row]
            cell.textView.text = (data[sectionNames[indexPath.section]] as? NSDictionary)?[dataSort[indexPath.section][indexPath.row]] as? String ?? kblankString
            cell.tableViewDelegate = (self)
            cell.section = indexPath.section
            cell.row = indexPath.row
           
            if editLabel == "Edit"{
                cell.textView.borderWidth = 0
                cell.textView.isEditable = false
            }
            else{
                cell.textView.borderWidth = 1
                cell.textView.isEditable = true
                cell.addDone()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("~* make some magic at row: \(indexPath.row) *~")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 359, height: 55))
        EditSaveButton.frame =  CGRect(x: tableView.frame.width-100, y: 17, width: 60, height: 20)
        let countCheck = header.subviews.filter({$0.tag == 13}).count
        EditSaveButton.isHidden = false
        if section == 0 {
            EditSaveButton.isHidden = false
            if !header.subviews.contains(EditSaveButton) && countCheck == 0{
                EditSaveButton.addTarget(self, action: #selector(editSave(_:)), for: .touchUpInside)
                header.addSubview(EditSaveButton)
                print("editsavebutton")
            }
        }
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: header.frame.width-10, height: header.frame.height-10)
        label.text = sectionNames[section]
        label.font = UIFont.boldSystemFont(ofSize: 14) // my custom font
        label.textColor = UIColor.darkGray // my custom colour
        
        header.addSubview(label)
        return header
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
       UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
       
}

extension DotDetailsView {
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds , collectionViewLayout: generateLayout())
        //        view.addSubview(collectionView)
        
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        // register collection view to different types of cells
        collectionView.register(DotAddDocsCell.self, forCellWithReuseIdentifier: DotAddDocsCell.reuseIdentifier)
        //For registering sections
        
        CardsCollectionView = collectionView
        //        CardsCollectionView.edgesToSuperview()
    }
    //dynamic for multi sections and layouts
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let isWideView = layoutEnvironment.container.effectiveContentSize.width > 500
            //add cases with sections
            let sectionLayoutKind = Section.allCases[sectionIndex]
            switch (sectionLayoutKind) {
            case .main: return self.generateMyAlbumsLayout(isWide: isWideView)
            }
        }
        return layout
    }
    func generateMyAlbumsLayout(isWide: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 4, trailing: 0)
        
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(3.0),
            heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: addDocumentsLimiter)
        
        //TODO : - Add section header
        
        let section = NSCollectionLayoutSection(group: group)
        
        
        return section
    }
    private func configureCollectionViewDataSource() {
        // TODO: dataSource
        
        dataSource = DataSource(collectionView: CardsCollectionView, cellProvider: { (collectionView, indexpath, mov) -> DotAddDocsCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DotAddDocsCell.reuseIdentifier, for: indexpath) as? DotAddDocsCell
                else{fatalError("Could not create new cell")}
            cell.nameLabel.text =  self.dummyModel[indexpath.row].cardName
            //            cell.nameButton.setTitle( self.doctorDash[indexpath.row] , for: .normal)
            cell.isSelect = mov.isSelect ?? false
            if self.dummyModel[indexpath.row].cardName == ""{
                cell.DocumentImageView.image = #imageLiteral(resourceName: "icons8-plus-64")
            }
            else{
                cell.DocumentImageView.image = UIImage()
            }
            //            cell.cardImageView.image = DotLoginViewController.shared.signature == "Doctor" ? self.imagesArray[indexpath.row] : self.imagesArray1[indexpath.row]
            return cell
        })
    }
    private func createDummyData() {
        var dummyContacts: [AdddocumentsModel] = []
        let count = doctorDash.count
        for i in 0..<count {
            dummyContacts.append(AdddocumentsModel(cardName: "\(self.doctorDash[i])", cardTitle: "Test\(i)",isSelect: false))
            
        }
        dummyModel = dummyContacts
        applySnapshot(items: dummyContacts)
        
    }
    private func applySnapshot(items: [AdddocumentsModel]) {
        
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot,animatingDifferences: true)
    }
    func openDocumentPicker(){
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    func showPreview(url: String){
    //     Instantiate the interaction controller
//                if let file = URL(string: url){
//                           let previewQL = QLPreviewController() // 4
//                           previewQL.dataSource = self // 5
//                           previewQL.currentPreviewItemIndex = docIndex // 6
//                            show(previewQL, sender: nil) // 7
//        
//                       }else {
//                           print("File missing! Button has been disabled")
//                       }
    }
}

extension DotDetailsView: UICollectionViewDelegate,UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        docIndex = indexPath.row
        if item.cardName == ""{
            openDocumentPicker()
        }
        else{
            showPreview(url: item.cardTitle!)
        }
        
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print(url)
        
        print(url.lastPathComponent.split(separator: "_").first!)
        
        print(url.pathExtension)
        let newCard = AdddocumentsModel(cardName: "", cardTitle: "", selectedImage: UIImage(), isSelect: false)
        
        var model = dummyModel.remove(at: docIndex)
        model.cardName = (url.lastPathComponent.components(separatedBy: "-").first) ?? ""
        model.cardTitle = "\(url)"
        dummyModel.insert(model, at: docIndex)
        dummyModel.insert(newCard, at: dummyModel.count)
        applySnapshot(items: dummyModel)
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

extension DotDetailsView: ProfilePictureUpdatedProtocol {
    func updateProfilePictur(image:UIImage?) {
        if let image = image {
            DispatchQueue.main.async {
                self.profileImage.image = image
            }
        }
    }
}

