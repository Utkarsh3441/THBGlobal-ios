//
//  DotLoginViewController.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 05/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit
import SVProgressHUD
import WebKit
class DotLoginViewController: UIViewController {
    @IBOutlet weak var passwordTextField: DotTextFieldUtility!
     public static let shared = DotLoginViewController()
    public static var autoSignIn = true
    @IBOutlet weak var userNameTextField: DotTextFieldUtility!
    @IBOutlet weak var signIn: LoadingButton!
    @IBOutlet weak var bgImage: UIImageView!
     @IBOutlet weak var maskImage: UIImageView!
    @IBOutlet weak var proImage: UIImageView!
    @IBOutlet weak var TCPlabel:UILabel!
    @IBOutlet weak var TCPView:UITextView!
    var iconClick = true
    private var User = ""
    private var password = ""
    var eyeButton:UIButton = UIButton(type: .custom)
    private let client = DotConnectionClient()
    lazy var webView:WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
     lazy var WebVc = UIViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
    eyeButton.setImage(UIImage(systemName:"eye.slash")?.withTintColor(Theme.gradientColorLight!), for: .normal)
        eyeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        eyeButton.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
        eyeButton.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
        signIn.hideLoading()
        signIn.setTitle("Sign In", for: .normal)
        signIn.isEnabled = true
        signIn.titleLabel?.textAlignment = .right
        WebVc.view.addSubview(webView)
        webView.edgesToSuperview()
        let attributedString = NSMutableAttributedString().createAttributedString(first: "              Privacy Policy | Terms and Conditions", second: "", fColor: Theme.backgroundColor!, sColor: .white, fBold: true, sBold: false, fSize: 16, sSize: 16)
        let linkSet1 = attributedString.setAsLink(textToFind: "Privacy Policy", linkURL:  "https://www.ashacares.com/privacy-policy")
        let linkSet2 = attributedString.setAsLink(textToFind: "Terms and Conditions", linkURL:  "https://www.ashacares.com/terms-of-use")
        if linkSet1 && linkSet2 {
            TCPView.attributedText = attributedString
        }
        passwordTextField.delegate = self
        userNameTextField.delegate = self
//        passwordTextField.addDoneButton(title: "DONE", target: self, selector: #selector(tapDone(sender:)))
//        userNameTextField.addDoneButton(title: "DONE", target: self, selector: #selector(tapDone(sender:)))
        
        // Do any additional setup after loading the view.
    }
    @objc func tapDone(sender: FloatingLabelInput) {
                view.endEditing(true)
       }
   @objc func refresh(_ sender: Any) {
         if(iconClick == true) {
             passwordTextField.isSecureTextEntry = false
            eyeButton.setImage(UIImage(systemName:"eye")?.withTintColor(Theme.gradientColorLight!), for: .normal)
         } else {
             passwordTextField.isSecureTextEntry = true
             eyeButton.setImage(UIImage(systemName:"eye.slash")?.withTintColor(Theme.gradientColorLight!), for: .normal)
             
         }
         
         iconClick = !iconClick
     }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        
        
        checkLoginData(){ [weak self]result in
            guard let self = self else { return }
            if result{
                            self.maskImage.isHidden = false
                            DotLoginViewController.autoSignIn = true
                            
                            self.signInUser(account:keyChainPrefix.patientAccount.rawValue)
            //                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //                    let sameViewController = storyboard.instantiateViewController(withIdentifier: "mainTab") as! DotTabViewController
            //                    self.navigationController?.pushViewController(sameViewController, animated: true)
            //                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                            
                            
                        }
            else{
                    self.maskImage.isHidden = true
                    DotLoginViewController.autoSignIn = false

                
            }
        }
        
    }
    func checkLoginData(completion :@escaping (Bool) -> Void){
        if let pass = (KeychainService.loadPassword(service: keyChainPrefix.loginSession.rawValue, account: keyChainPrefix.patientAccount.rawValue)),let user = (KeychainService.loadPassword(service: keyChainPrefix.loginUsername.rawValue, account: keyChainPrefix.patientAccount.rawValue)) {
            password = pass
            User = user
            if DotLoginViewController.autoSignIn == true {
                completion(true)
            }
            else{
                userNameTextField.text = user
                passwordTextField.text = pass
                completion(false)
            }
        }
        else{
            completion(false)
        }
        
    }
    @IBAction func signInAction(_ sender: Any) {
        print("sign in clicked")
        self.signIn.showLoading()
        self.signInUser(account:keyChainPrefix.patientAccount.rawValue)
    }
    @IBAction func forgotPassword(_ sender: Any) {
        let myRequest = URLRequest(url: URL(string: "https://www.ashacares.com/forgot-password")!)
        webView.load(myRequest)
        self.present(WebVc, animated: true, completion: nil)
    }
    func signInAct(account:String) {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let sameViewController = storyboard.instantiateViewController(withIdentifier: "mainTab") as! DotTabViewController
      self.navigationController?.pushViewController(sameViewController, animated: true)
      self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    @IBAction func signUpAction(_ sender: Any) {
        showRegister()
        
    }
    func showRegister(){
        self.navigationController?.pushViewController(DotRegisterViewController(), animated: true)
        self.navigationController?.navigationBar.topItem?.title = "Register"
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func setConstants(userDetails:loginDetails?){
        KeychainService.savePassword(service: "sessions", account: keyChainPrefix.patientAccount.rawValue , data: self.passwordTextField.text ?? kblankString)
        KeychainService.savePassword(service: keyChainPrefix.loginUsername.rawValue, account: keyChainPrefix.patientAccount.rawValue , data: self.userNameTextField.text ?? kblankString)
        loginData.user_email = userDetails?.user_email
        loginData.user_id = userDetails?.user_id
        loginData.user_name = userDetails?.user_name
        loginData.user_type = userDetails?.user_type
    }
    // MARK:- API Calls
    func signInUser(account:String){
        if DotLoginViewController.autoSignIn == true
{
            SVProgressHUD.show(withStatus: "Signing In, Please Wait.")
        }
           // Query item
           let queryItem = [ URLQueryItem(name: "keyName", value: "ValueName") ]
           /*
           // Body as string
           let bodyString = "yourParameterString"
           let body = bodyString.data(using: .utf8) */
           
           // Body as dictionary
           var paramsDictionary = [String:String]()
        paramsDictionary["username"] = DotLoginViewController.autoSignIn ? User : (userNameTextField.text ?? kblankString) //"john@doe10.com"
        paramsDictionary["password"] = DotLoginViewController.autoSignIn ? password : (passwordTextField.text ?? kblankString) //password
           paramsDictionary["usertype"] = account

           guard let body = try? JSONSerialization.data(withJSONObject: paramsDictionary) else { return }

           // Headers
          let headers = ["Content-Type":"application/json"]
           
           let api: API = .api1
           let endpoint: Endpoint = api.getPostAPIEndpoint(urlString: "\(api.rawValue)sessions", queryItems: nil, headers: headers, body: body)
           
           client.userLogin(from: endpoint) { [weak self] result in
               guard let self = self else { return }
               switch result {
               case .success(let model2Result):
                   DotLoginViewController.autoSignIn = true
                    self.signIn.hideLoading()
                   SVProgressHUD.dismiss()
                   guard let model2Result = model2Result else { return }
                   print(model2Result)
                   if let dataModel = (model2Result as? networkModel){
                    switch dataModel.type{
                    case "error":self.showAlertView("Login Failed", message: dataModel.description)
                       self.maskImage.isHidden = true
                       default:
                        self.setConstants(userDetails: dataModel.data.first)
                        self.signInAct(account: keyChainPrefix.patientAccount.rawValue)
                       }
                   }else {
                           self.showAlertView("Login Failed", message: "Some Error Occured")
                         self.maskImage.isHidden = true
                       }
                   
                  
                   
               case .failure(let error):
                    DotLoginViewController.autoSignIn = false
                    self.signIn.hideLoading()
                    SVProgressHUD.dismiss()
                    self.maskImage.isHidden = true
                    if case let APIError.errorAllResponse(description, message, _) = error {
                        self.showAlertView(message, message: description)
                    }
                   print("the error \(error)")
               }
           }
       }
    
    
}
extension DotLoginViewController: WKUIDelegate,WKNavigationDelegate{
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
}

extension DotLoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
