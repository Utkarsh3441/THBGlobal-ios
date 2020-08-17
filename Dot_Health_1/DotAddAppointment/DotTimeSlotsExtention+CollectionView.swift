//
//  DotTimeSlotsExtention+CollectionView.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 20/07/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation

extension DotTimeSlotViewController {
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds , collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        // register collection view to different types of cells
        collectionView.register(DotTimeSlotsCollectionCell.self, forCellWithReuseIdentifier: DotTimeSlotsCollectionCell.reuseIdentifier)
        //For registering sections
        
        CardsCollectionView = collectionView
        slotsView.addSubview(CardsCollectionView)
        CardsCollectionView.edgesToSuperview()
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
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 4, trailing: 15)
        
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        //TODO : - Add section header
        
        let section = NSCollectionLayoutSection(group: group)
        
        
        return section
    }
     func configureCollectionViewDataSource() {
        // TODO: dataSource
        
        dataSource = DataSource(collectionView: CardsCollectionView, cellProvider: { (collectionView, indexpath, mov) -> DotTimeSlotsCollectionCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DotTimeSlotsCollectionCell.reuseIdentifier, for: indexpath) as? DotTimeSlotsCollectionCell else{fatalError("Could not create new cell")}
            cell.nameLabel.text =  self.doctorDash[indexpath.row]
//            cell.nameButton.setTitle( self.doctorDash[indexpath.row] , for: .normal)
            cell.isSelect = mov.isSelect ?? false
            if self.green.contains(mov.id ?? 0){
                cell.changeColor(state: "completed")
            }
            else if self.red.contains(mov.id ?? 0){
                cell.changeColor(state: "booked")
            }
            else if mov.isSelect! && !(self.red.contains(mov.id ?? 0)) && !(self.green.contains(mov.id ?? 0)){
                cell.changeColor(state: "selected")
            }
            else{
                cell.changeColor(state: "available")
            }
//            cell.cardImageView.image = DotLoginViewController.shared.signature == "Doctor" ? self.imagesArray[indexpath.row] : self.imagesArray1[indexpath.row]
            return cell
        })
    }
     func createDummyData() {
        var dummyContacts: [DotSlotsModel] = []
        let count = doctorDash.count
        for i in 0..<count {
           dummyContacts.append(DotSlotsModel(cardName: "\(self.doctorDash[i])", cardTitle: "Test\(i)",isSelect: false,id: i))
            
        }
        dummyModel = dummyContacts
        applySnapshot(items: dummyContacts)
        
    }
    private func applySnapshot(items: [DotSlotsModel]) {
        
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot,animatingDifferences: true)
    }
}

extension DotTimeSlotViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
    var selectItem = dummyModel[item.id ?? 0]
    selectItem.isSelect = !(selectItem.isSelect ?? false)
    dummyModel.remove(at: item.id ?? 0)
    dummyModel.insert(selectItem, at: item.id ?? 0)
    applySnapshot(items: dummyModel)
//    dummyModel[indexPath.row]
//    switch item.cardName {
//    case "Appointments":
//        let storyBoard : UIStoryboard = UIStoryboard(name: String(describing: DotAppointmentsViewController.self), bundle:nil)
//        let nextViewController = storyBoard.instantiateInitialViewController() as! DotAppointmentsViewController
//        nextViewController.itemName = "My Appointments"
//        let _ = nextViewController.view
//
//        self.delegate?.addChildViewController(nextViewController, back: true)
//
//    default:
//       self.delegate?.addChildViewController(returnDummyView(), back: true)
//    }
//    let albumDetailVC = AlbumDetailViewController(withPhotosFromDirectory: item.albumURL)
//    navigationController?.pushViewController(albumDetailVC, animated: true)
  }
}
protocol saveAddedSlots : class{
    func addSlot(_ arr:[String])
}
