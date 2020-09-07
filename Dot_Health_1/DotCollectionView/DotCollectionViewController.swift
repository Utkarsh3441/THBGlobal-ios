//
//  DotCollectionViewController.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 08/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class DotCollectionViewController: UIViewController {
    enum Section :CaseIterable{
        case main
    }
    
    // MARK: DataSource & DataSourceSnapshot typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Section,DotCardModel>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section,DotCardModel>
    // MARK: dataSource & snapshot
    private var dataSource :DataSource! =  nil
    private var snapshot = DataSourceSnapshot()
    var collectionSuperView = UIView()
    var dashBoardObj = DotDashboardViewController()
    var CardsCollectionView: UICollectionView! = nil
//    var labelArray = ["My Health Records","Appointments","Contact Care Coordinator","Talk to Doctor","Health Info"]//make //,"More THB"didset
    var labelArray = ["My Health Records","Appointments","Contact Care Coordinator","Health Info"]//make //,"More THB"didset

    var imagesArray = [#imageLiteral(resourceName: "Health-Records") ,#imageLiteral(resourceName: "Appointments") ,#imageLiteral(resourceName: "24-7-Doctor"),#imageLiteral(resourceName: "Talk-to-THB"),#imageLiteral(resourceName: "Health-Info"),#imageLiteral(resourceName: "More-THB")]//make Didset
    var identiFierForView:String?
    var healthRecordLabelArray = ["Vitals","Clinical Visits","Medications","Records","Care Plan"]//,"Tele consult"//make didset
    var healthRecordImages = [#imageLiteral(resourceName: "vitals") ,#imageLiteral(resourceName: "Clinical-Visits") ,#imageLiteral(resourceName: "Medication"),#imageLiteral(resourceName: "Records"),#imageLiteral(resourceName: "Care-Plan"),#imageLiteral(resourceName: "Tele-Consult")]//make Didset
    weak var delegate:setViewControllerAutomatically?
    override func viewDidLoad() {
        super.viewDidLoad()
      
        configureCollectionView()
        configureCollectionViewDataSource()
        createDummyData()
       
        
        // Do any additional setup after loading the view.
    }
    func setBounds(bound:CGRect){
        self.collectionSuperView.frame = bound
    }
    func returnDummyView()->UIViewController{
        let dummy = UIViewController()
        let label = UILabel()
        label.text = "Work In Progress"
        label.font = UIFont.boldSystemFont(ofSize: 25) // my custom font
        label.textColor = UIColor.systemBlue // my custom colour
        dummy.view.addSubview(label)
        dummy.view.backgroundColor = .white
        label.center(in: dummy.view)
        return dummy
    }
}
extension DotCollectionViewController {
       func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds , collectionViewLayout: generateLayout())
         view.addSubview(collectionView)
       
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = Theme.backgroundColor
        collectionView.delegate = self
        // register collection view to different types of cells
         collectionView.register(DotCardCell.self, forCellWithReuseIdentifier: DotCardCell.reuseIdentifier)
        //For registering sections

        CardsCollectionView = collectionView
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
      item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
      let groupHeight = NSCollectionLayoutDimension.fractionalWidth(0.465)
      let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(CardsCollectionView.bounds.height/3))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

      //TODO : - Add section header

      let section = NSCollectionLayoutSection(group: group)
      

      return section
    }
    private func configureCollectionViewDataSource() {
        // TODO: dataSource
     
        dataSource = DataSource(collectionView: CardsCollectionView, cellProvider: { (collectionView, indexpath, mov) -> DotCardCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DotCardCell.reuseIdentifier, for: indexpath) as? DotCardCell else{fatalError("Could not create new cell")}
            cell.nameLabel.text = self.identiFierForView == "1" ? self.healthRecordLabelArray[indexpath.row] : self.labelArray[indexpath.row]
            cell.cardImageView.image = self.identiFierForView == "1" ? self.healthRecordImages[indexpath.row] : self.imagesArray[indexpath.row]
            cell.tintColor = .white
            return cell
        })
    }
    private func createDummyData() {
        var dummyContacts: [DotCardModel] = []
        
        if self.identiFierForView == "1" {
            for i in 0..<healthRecordLabelArray.count {
                dummyContacts.append(DotCardModel(cardName: "\(self.healthRecordLabelArray[i])", cardTitle: "Test\(i)"))
            }
        } else {
            for i in 0..<labelArray.count {
                
                dummyContacts.append(DotCardModel(cardName: "\(self.labelArray[i])", cardTitle: "Test\(i)"))
            }
        }
        applySnapshot(items: dummyContacts)
    }
    
    private func applySnapshot(items: [DotCardModel]) {
        
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot,animatingDifferences: true)
    }
}
extension DotCollectionViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
    switch item.cardName {
    case "Appointments":
        let storyBoard : UIStoryboard = UIStoryboard(name: String(describing: DotAppointmentsViewController.self), bundle:nil)
        let nextViewController = storyBoard.instantiateInitialViewController() as! DotAppointmentsViewController
        nextViewController.itemName = "My Appointments"
        let _ = nextViewController.view
       
        self.delegate?.addChildViewController(nextViewController, back: true)
    case "My Health Records":
       let storyBoard : UIStoryboard = UIStoryboard(name: "DashBoardCollectionVIewStoryboard", bundle:nil)
              let nextViewController = storyBoard.instantiateInitialViewController() as! DashBoardCollectionViewController
       
              let _ = nextViewController.view
        self.delegate?.addChildViewController(nextViewController, back: true)
    case "Vitals":
        let storyBoard : UIStoryboard = UIStoryboard(name: "DotVitalsViewController", bundle:nil)
               let nextViewController = storyBoard.instantiateInitialViewController() as! DotVitalsViewController
        
               let _ = nextViewController.view
         self.delegate?.addChildViewController(nextViewController, back: true)
 
       
    case "Clinical Visits":
        
         let storyBoard : UIStoryboard = UIStoryboard(name: "DotAppointmentsViewController", bundle:nil)
         let nextViewController = storyBoard.instantiateInitialViewController() as! DotAppointmentsViewController
          nextViewController.itemName = "My Clinical Visits"
         let _ = nextViewController.view
        self.delegate?.addChildViewController(nextViewController, back: true)
    case "Records":
         
         let nextViewController = DotRecordsViewController()
        self.delegate?.addChildViewController(nextViewController, back: true)
    case "Talk to Doctor":
       
      self.delegate?.showActionSheet()
       
    case "Medications":
        let storyBoard : UIStoryboard = UIStoryboard(name: String(describing: DotAddAppointmentViewController.self), bundle:nil)
         let nextViewController = storyBoard.instantiateInitialViewController() as! DotAddAppointmentViewController
        nextViewController.screenName = item.cardName ?? kblankString
         let _ = nextViewController.view
        
         self.delegate?.addChildViewController(nextViewController, back: true)
    case "Care Plan":
        let nextViewController = DotCarePlanController()
       
         self.delegate?.addChildViewController(nextViewController, back: true)

    default:
       self.delegate?.addChildViewController(returnDummyView(), back: true)
    }
//    let albumDetailVC = AlbumDetailViewController(withPhotosFromDirectory: item.albumURL)
//    navigationController?.pushViewController(albumDetailVC, animated: true)
  }
}

protocol setViewControllerAutomatically : class{
    func addChildViewController(_ views: UIViewController, back:Bool)
    func showActionSheet()
    
}
