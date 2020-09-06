//
//  DotPaymentsController.swift
//  tinder_messages_screen
//
//  Created by Animesh Mohanty on 05/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import LBTATools
import FittedSheets
import SVProgressHUD

class DotPaymentsController: LBTAListController<DotPaymentsCell, DotPaymentsModel>, UICollectionViewDelegateFlowLayout {
    static let sharedInstance = DotPaymentsController()
    var dataItems = [DotPaymentsModel]()
    private let client = DotConnectionClient()

    var controller =  UIStoryboard(name: "DotPaymentSheet", bundle: nil).instantiateInitialViewController() as! DotPaymentSheetController
    override func viewDidLoad() {
        super.viewDidLoad()
        getPaymentHistory()
        navigationItem.title = "Payment History"
        
        collectionView.backgroundColor = Theme.backgroundColor
        collectionView.isScrollEnabled = true
        collectionView.flashScrollIndicators()

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

extension DotPaymentsController {
    
func getPaymentHistory() {
    SVProgressHUD.show()
    
    var queryItem = [URLQueryItem(name: "userType", value:"patients")]
    if let userId = loginData.user_id {
        queryItem.append(URLQueryItem(name: "userId", value: String(userId)))

    }
   
    
    let api: API = .api1
    let endpoint: Endpoint = api.getPostAPIEndpointForMedication(urlString: "\(api.rawValue)payments", queryItems: queryItem, headers: nil, body: nil)
    client.callAPI(with: endpoint.request, modelParser: [DotPaymentsModel].self) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let model2Result):
            SVProgressHUD.dismiss()
            
            if let model = model2Result as? [DotPaymentsModel] {
                self.items = model
                DotPaymentsController.sharedInstance.dataItems = self.items
            }
            else{
                print("error occured")
                SVProgressHUD.dismiss()
            }
        case .failure(let error):
            
            SVProgressHUD.dismiss()
            if case let APIError.errorAllResponse(description, message, _) = error {
                self.showAlertView(message, message: description)
            }
        }
    }
    
}
}
