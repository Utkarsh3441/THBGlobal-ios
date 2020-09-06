//
//  DotSettingsViewController.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 13/08/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit
import WebKit
import TinyConstraints
import SVProgressHUD
class DotSettingsViewController: UIViewController {
 @IBOutlet weak var tableViw : UITableView!
 @IBOutlet weak var logOut : UIButton!
    var dataArray = ["My Profile","Change Password","My Payment","FAQ","Terms and Conditions","Privacy Policy"]
    var imgArray = [#imageLiteral(resourceName: "My-Profile"),#imageLiteral(resourceName: "Change-Password"),#imageLiteral(resourceName: "My-Payment"),#imageLiteral(resourceName: "FAQ"),#imageLiteral(resourceName: "Terms-and-Conditions"),#imageLiteral(resourceName: "Privacy-Policy")]
    lazy var WebVc = UIViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        WebVc.view.addSubview(webView)
        webView.edgesToSuperview()
        
                // Do any additional setup after loading the view.
    }
    lazy var webView:WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
        let _ = self.parent?.navigationController?.popViewController(animated: true)

        // navigationController?.popToRootViewController(animated: true)
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: DotLoginViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
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
        tableView.deselectRow(at: indexPath, animated: true)
        if dataArray[indexPath.row] == "My Profile"{
            let storyBoard : UIStoryboard = UIStoryboard(name: "DotDetailsStoryboard", bundle:nil)
            let nextViewController = storyBoard.instantiateInitialViewController() as! DotEditDetailsViewController
            let _ = nextViewController.view
            self.present(nextViewController, animated: true, completion: nil)
            
        }
        else if dataArray[indexPath.row] == "My Payment"{
            self.navigationController?.pushViewController(DotPaymentsController(), animated: true)
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.navigationBar.barTintColor = Theme.accentColor
            self.navigationController?.navigationBar.tintColor = Theme.tintcolor
            self.navigationController?.navigationBar.isTranslucent = false
        }
        else if dataArray[indexPath.row] == "FAQ"{
           
            let myRequest = URLRequest(url: URL(string: "https://www.ashacares.com/faq")!)
            webView.load(myRequest)
        
            self.present(WebVc, animated: true, completion: nil)
        }
        else if dataArray[indexPath.row] == "Terms and Conditions"{
    
                       let myRequest = URLRequest(url: URL(string: "https://www.ashacares.com/terms-of-use")!)
                       webView.load(myRequest)
                       self.present(WebVc, animated: true, completion: nil)
            
        }
        else if dataArray[indexPath.row] == "Privacy Policy"{
                                  let myRequest = URLRequest(url: URL(string: "https://www.ashacares.com/privacy-policy")!)
                                  webView.load(myRequest)
                                  self.present(WebVc, animated: true, completion: nil)
        }
        else if dataArray[indexPath.row] == "Change Password"{
                                  let myRequest = URLRequest(url: URL(string: "https://www.ashacares.com/forgot-password")!)
                                  webView.load(myRequest)
                                  self.present(WebVc, animated: true, completion: nil)
        }
    }
}
extension DotSettingsViewController: WKUIDelegate,WKNavigationDelegate{
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
}
