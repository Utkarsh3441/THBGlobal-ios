//
//  DotPaymentsController.swift
//  tinder_messages_screen
//
//  Created by Animesh Mohanty on 05/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import LBTATools
import FittedSheets

class DotPaymentsController: LBTAListController<DotPaymentsCell, DotPaymentsModel>, UICollectionViewDelegateFlowLayout {
    static let sharedInstance = DotPaymentsController()
    var dataItems = [DotPaymentsModel]()
    var controller =  UIStoryboard(name: "DotPaymentSheet", bundle: nil).instantiateInitialViewController() as! DotPaymentSheetController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Payment History"
        collectionView.backgroundColor = Theme.backgroundColor
        collectionView.isScrollEnabled = true
        collectionView.flashScrollIndicators()
        items = [
            .init(price: "$1300",tID:"TXTN123456", text: "Payment Successful", col: .red, state: 1),
            .init(price: "$1300",tID:"TXTN123456" ,text: "Payment Failed", col: .red, state: 0),
            .init(price: "$1300",tID:"TXTN123456" ,text: "Payment Processing", col: .red, state: 2),
            .init(price: "$1300",tID:"TXTN123456" ,text: "Payment Successful", col: .red, state: 1),
            .init(price: "$1300",tID:"TXTN123456" ,text: "Payment Failed", col: .red, state: 0),
            .init(price: "$1300",tID:"TXTN123456" ,text: "Payment Processing", col: .red, state: 2),
            .init(price: "$1300",tID:"TXTN123456" ,text: "Payment Failed", col: .red, state: 0),
            .init(price: "$1300",tID:"TXTN123456" ,text: "Payment Successful", col: .red, state: 1),
            .init(price: "$1300",tID:"TXTN123456" ,text: "Payment Processing", col: .red, state: 2),
            .init(price: "$1300",tID:"TXTN123456", text: "Payment Failed", col: .red, state: 0)
            
        ]
        DotPaymentsController.sharedInstance.dataItems = items
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 20, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controller.selectedModel = items[indexPath.row]
        controller.makeDateArr()
       
        let sheetController = SheetViewController(controller: controller, sizes: [.fixed(250), .halfScreen])
        
        
        sheetController.adjustForBottomSafeArea = false
        sheetController.blurBottomSafeArea = true
        sheetController.dismissOnBackgroundTap = true
        sheetController.extendBackgroundBehindHandle = false
        sheetController.topCornersRadius = 15
        
        sheetController.willDismiss = { _ in
            print("Will dismiss ")
        }
        sheetController.didDismiss = { _ in
            print("Will dismiss ")
        }
        
        self.present(sheetController, animated: false, completion: nil)
    }
}
