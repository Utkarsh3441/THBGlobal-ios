//
//  DotSettingsViewController.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 13/08/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class DotSettingsViewController: UIViewController {
 @IBOutlet weak var tableViw : UITableView!
 @IBOutlet weak var logOut : UIButton!
    var dataArray = ["My Profile","Change Password","My Payment","FAQ","Terms and Conditions","Privacy Policy"]
    var imgArray = [#imageLiteral(resourceName: "My-Profile"),#imageLiteral(resourceName: "Change-Password"),#imageLiteral(resourceName: "My-Payment"),#imageLiteral(resourceName: "FAQ"),#imageLiteral(resourceName: "Terms-and-Conditions"),#imageLiteral(resourceName: "Privacy-Policy")]
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutAction(_ sender: Any) {
    let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
           alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
              // KeychainService.removePassword(service: keyChainPrefix.loginSession.rawValue, account: DotLoginViewController.shared.signature ?? kblankString)
               KeychainService.removePassword(service: keyChainPrefix.loginSession.rawValue, account: keyChainPrefix.patientAccount.rawValue)
               KeychainService.removePassword(service: keyChainPrefix.loginUsername.rawValue, account: keyChainPrefix.patientAccount.rawValue)
               self.signingOut()
           }))
           alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           present(alertController, animated: true, completion: nil)
       }
       func signingOut(){
           navigationController?.popToRootViewController(animated: true)
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension DotSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
  
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let val = dataArray[indexPath.row]
        cell.textLabel?.text = val
        cell.imageView?.image = imgArray[indexPath.row].withTintColor(Theme.accentColor!, renderingMode: .alwaysOriginal)
        cell.textLabel?.font = .systemFont(ofSize: 18)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataArray[indexPath.row] == "My Profile"{
            let storyBoard : UIStoryboard = UIStoryboard(name: "DotDetailsStoryboard", bundle:nil)
            let nextViewController = storyBoard.instantiateInitialViewController() as! DotEditDetailsViewController
            //nextViewController.itemName = "Mtalk to THB"
//            nextViewController.profileData = editPatientDetails
            let _ = nextViewController.view
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        else if dataArray[indexPath.row] == "My Payment"{
           
                        self.navigationController?.pushViewController(DotPaymentsController(), animated: true)
        }
    }
}
