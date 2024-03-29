//
//  ResultController.swift
//  TelrSDKDemo
//
//  Created by Onkar Borse on 17/04/19.
//  Copyright © 2019 Girish. All rights reserved.
//

import UIKit
import TelrSDK
class ResultController: TelrResponseController {

    @IBOutlet var statuslabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let trans = "Transfer reference: \(tranRef ?? "")"
        
        statuslabel.text = message! + "\n" + trans
        
        if let ref = tranRef{
            saveData(key: "ref", value: ref)
        }
        if let firstref = transFirstRef{
            saveData(key: "firstref", value: firstref)
        }
        if let last4 = cardLast4{
            saveData(key: "last4", value: last4)
        }
        
        // Return payment results
        
        print("Return payment results")
        print(trace as Any)
        print(status as Any)
        print(avs as Any)
        print(code as Any)
        print(ca_valid as Any)
        print(cardCode as Any)
        print(cardLast4 as Any)
        print(cvv as Any)
        print(tranRef as Any)
        print("transFirstRef \(transFirstRef ?? "no")")
        
        //        print(trace!)
        //        print(status!)
        //        print(avs!)
        //        print(code!)
        //        print(ca_valid!)
        //        print(cardCode!)
        //        print(cardLast4!)
        //        print(cvv!)
        //        print(tranRef!)
        
    }
    
    
    @IBAction func backbtnPressed(_ sender: Any) {
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: DotAddAppointmentViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        
//        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DotDashboardViewController") as! DotDashboardViewController
//
//        //self.navigationController?.pushViewController(viewController, animated: true)
//
//        //self.present(viewController, animated: true, completion: nil)
//
//        let navigationController = UINavigationController(rootViewController: viewController)
//        let appdelegate = UIApplication.shared.delegate as! AppDelegate
//        appdelegate.window!.rootViewController = navigationController
    }
    
    private func saveData(key:String, value:String){
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }


}


