//
//  DashBoardCollectionViewController.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 20/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit
import TinyConstraints
class DashBoardCollectionViewController: UIViewController {
    @IBOutlet weak var myView:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let collectionViewObj = DotCollectionViewController()
        collectionViewObj.identiFierForView = "1"
        collectionViewObj.delegate = self
        let _ = collectionViewObj.view
        
        let view = collectionViewObj.CardsCollectionView
        self.myView.addSubview(view ?? UIView())
        view?.edgesToSuperview()
        self.navigationItem.title = "My Health Records"
        // Do any additional setup after loading the view.
    }

}
extension DashBoardCollectionViewController:setViewControllerAutomatically{
    func showActionSheet(){
          let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
          let chat = UIAlertAction(title: "Chat", style: .default) { (action) in
             
          }
          let call = UIAlertAction(title: "Audio/Video call", style: .default) { (action) in
             
          }
          let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          
          actionSheet.addAction(chat)
          actionSheet.addAction(call)
          actionSheet.addAction(cancel)
          
          present(actionSheet,animated: true,completion: nil)
      }

func addChildViewController(_ views:UIViewController, back: Bool) {
    self.navigationController?.pushViewController(views, animated: true)
    self.navigationController?.navigationBar.barTintColor = Theme.accentColor
    self.navigationController?.navigationBar.tintColor = Theme.tintcolor
    self.navigationController?.navigationBar.isTranslucent = false
  
}
}
