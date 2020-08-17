//
//  DotCarePlanController.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 12/08/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import LBTATools
import FittedSheets
import SVProgressHUD
class DotCarePlanController: LBTAListController<DotCarePlanCell, DotCarePlanModelGet>, UICollectionViewDelegateFlowLayout {
    static let sharedInstance = DotCarePlanController()
    var dataItems = [DotCarePlanModel]()
    let client = DotConnectionClient()
    var controller =  UIStoryboard(name: "DotSettingsBoard", bundle: nil).instantiateInitialViewController() as! DotCareSheet
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Care Plan"
        collectionView.backgroundColor = Theme.backgroundColor
        collectionView.isScrollEnabled = true
        collectionView.flashScrollIndicators()
        
        getCarePlan()
//        DotPaymentsController.sharedInstance.dataItems = items
    }
    func getCarePlan(){
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.custom)
            let api : API = .patientsApi
        let endpoint: Endpoint = api.getPostAPIEndpointForAll(urlString: "\(api.rawValue)\(loginData.user_id ?? 17)/careplans", httpMethod: .get, queryItems: nil, headers: nil, body: nil)
                    client.callAPI(with: endpoint.request, modelParser: String.self) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let model2Result):
                        SVProgressHUD.dismiss()
                        print(model2Result)
                        if let model = model2Result as? [DotCarePlanModelGet]{
                            self.items = model
                        }
                        else{
                            self.items = [
                                .init (details_four: "Test", details_one: "test1", details_three: "test3", details_two: "test2", name: "Post Operation",status: "ACTIVE"),
                                
                                 .init(details_four: "Test", details_one: "test1", details_three: "test3", details_two: "test2", name: "Diagnostics Advice", status: "ACTIVE")
                            ]
                            print("error occured")
                        }
                    case .failure(let error):
                        SVProgressHUD.dismiss()

                        print("the error \(error)")
                    }
                }
            
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        controller.selectedModel = items[indexPath.row]
//        controller.makeDateArr()
       
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
