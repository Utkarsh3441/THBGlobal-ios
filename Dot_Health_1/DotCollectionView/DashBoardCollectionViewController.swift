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


func addChildViewController(_ views:UIViewController, back: Bool) {
    self.navigationController?.pushViewController(views, animated: true)
    self.navigationController?.navigationBar.barTintColor = Theme.tintcolor
    self.navigationController?.navigationBar.tintColor = Theme.backgroundColor
    self.navigationController?.navigationBar.isTranslucent = false
  
}
}
