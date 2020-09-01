//
//  DotRecords+CollectionViewExtension.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 02/08/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation
extension DotRecordsViewController{
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
        item.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 4, trailing: 10)
        
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        //TODO : - Add section header
        
        let section = NSCollectionLayoutSection(group: group)
        
        
        return section
    }
     func configureCollectionViewDataSource() {
        // TODO: dataSource
        
        dataSource = DataSource(collectionView: CardsCollectionView, cellProvider: { (collectionView, indexpath, mov) -> DotAddDocsCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DotAddDocsCell.reuseIdentifier, for: indexpath) as? DotAddDocsCell
                else{fatalError("Could not create new cell")}
            cell.nameLabel.text =  mov.category ?? "Doc"
            //            cell.nameButton.setTitle( self.doctorDash[indexpath.row] , for: .normal)
            cell.isSelect = false
//            if self.dummyModel[indexpath.row].cardName == ""{
//                cell.DocumentImageView.image = #imageLiteral(resourceName: "icons8-plus-64")
//            }
//            else{
                cell.DocumentImageView.image = UIImage()
//            }
            //            cell.cardImageView.image = DotLoginViewController.shared.signature == "Doctor" ? self.imagesArray[indexpath.row] : self.imagesArray1[indexpath.row]
            return cell
        })
    }
     func createDummyData() {
        var dummyContacts: [AdddocumentsModel] = []
        let count = doctorDash.count
        for i in 0..<count {
            dummyContacts.append(AdddocumentsModel(cardName: "\(self.doctorDash[i])", cardTitle: "Test\(i)",isSelect: false))
            
        }
        dummyModel = dummyContacts
//        applySnapshot(items: dummyContacts)
        
    }
     func applySnapshot(items: [record]) {
        
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot,animatingDifferences: true)
    }
    private func deleteItems(_ item:record) {
    //        snapshot = DataSourceSnapshot()
        deleteFiles(items: item)
            let delay = 0.2 // Seconds
        if addedRecords.contains(item){
           DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.snapshot.deleteItems([item])
                self.recordsDataArray.removeAll(where: {$0 == item})
                self.dataSource.apply(self.snapshot,animatingDifferences: true)
            }
        }
            
    }
    func openDocumentPicker(){
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    func showPreview(url: URL) {
        // Instantiate the interaction controller
        // if let file = URL(string: url){
        self.documentController = UIDocumentInteractionController.init(url: url)
        self.documentController.delegate = self
        self.documentController.presentPreview(animated: true)
        //base64ToUrl
    }
}

extension DotRecordsViewController: UICollectionViewDelegate,UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        docIndex = indexPath.row
        
        loadSelectedFile(indexpath: indexPath.row)
        
//        if item.file_content != ""{
//            showPreview(url: item.file_content!)
//        }
//        if item.cardName == ""{
//            openDocumentPicker()
//        }
//        else{
//            showPreview(url: item.cardTitle!)
//        }
        
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
    
       return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.deleteItems(item)
            }
            return UIMenu(title: "Actions", children: [deleteAction])
        })
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print(url)
        
        print(url.lastPathComponent.split(separator: "_").first!)
        
        print(url.pathExtension)
//        let newCard = AdddocumentsModel(cardName: "", cardTitle: "", selectedImage: UIImage(), isSelect: false
       
        let new = record(category: (url.lastPathComponent) , file_content: "\(url)", medical_record_id: 1, patient_id: 17, storage_link: nil)
         if recordsDataArray.contains(new) || addedRecords.contains(new){
            self.showAlertView("Duplicate files", message: "File already present")
        }
        else{
            recordsDataArray.append(new)
            addedRecords.append(new)
            applySnapshot(items: recordsDataArray)
        }
        
//        var model = dummyModel.remove(at: docIndex)
//        model.cardName = (url.lastPathComponent)
//        model.cardTitle = "\(url)"
//        model.url = url
//        dummyModel.insert(model, at: docIndex)
//        dummyModel.insert(newCard, at: dummyModel.count)
//        applySnapshot(items: dummyModel)
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
