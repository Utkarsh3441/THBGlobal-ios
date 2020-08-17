//
//  DotPaymentSheetController.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 21/07/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class DotPaymentSheetController: UIViewController {
    @IBOutlet weak var tableViw : UITableView!
    var selectedModel : DotPaymentsModel!
    var arr = Array<Any>()
    var keyMap = NSMutableDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViw.rowHeight = 80
        tableViw.backgroundColor = Theme.gradientColorLight
        // Do any additional setup after loading the view.
    }
    func makeDateArr(){
        arr.removeAll()
        keyMap.removeAllObjects()
        arr.append(selectedModel.tID)
        keyMap.setValue("Payment ID", forKey: selectedModel.tID)
        arr.append(selectedModel.price)
        keyMap.setValue("Price", forKey: selectedModel.price)
        arr.append(selectedModel.text)
        keyMap.setValue("Status", forKey: selectedModel.text)
        arr.append("Help/Support : contact@abc.com")
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tableViw.reloadData()
    }
}
extension DotPaymentSheetController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
  
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let val = arr[indexPath.row] as? String
        
        if (val == selectedModel.price || val == selectedModel.text) && selectedModel.state == 0{
            
            cell.textLabel?.attributedText = NSAttributedString().createAttributedString(first: "\(keyMap.value(forKey: val ?? "") ?? ""): ", second: "\(val ?? "")", fColor: .black, sColor: .systemRed,fBold:true,sBold:false,fSize: 14,sSize: 14)
        }
        else if (val == selectedModel.price || val == selectedModel.text) && selectedModel.state == 1{
             cell.textLabel?.attributedText = NSAttributedString().createAttributedString(first: "\(keyMap.value(forKey: val ?? "") ?? ""): ", second: "\(val ?? "")", fColor: .black, sColor: .systemGreen,fBold:true,sBold:false,fSize: 14,sSize: 14)
        }
        else if (val == selectedModel.price || val == selectedModel.text) && selectedModel.state == 2{
              cell.textLabel?.attributedText = NSAttributedString().createAttributedString(first: "\(keyMap.value(forKey: val ?? "") ?? ""): ", second: "\(val ?? "")", fColor: .black, sColor: .systemOrange,fBold:true,sBold:false,fSize: 14,sSize: 14)
        }
        else{
             cell.textLabel?.attributedText = NSAttributedString().createAttributedString(first: "\(keyMap.value(forKey: val ?? "") ?? ""): ", second: "\(val ?? "")", fColor: .black, sColor: .white,fBold:true,sBold:false,fSize: 14,sSize: 14)
        }
        if val?.contains("Help/Support") ?? false{
            
            cell.textLabel?.attributedText = NSAttributedString().createAttributedString(first: "\(val?.components(separatedBy: ":").first ?? ""): ", second: "\( val?.components(separatedBy: ":").last ?? "")", fColor: #colorLiteral(red: 0.2069825828, green: 0.7254605889, blue: 1, alpha: 1), sColor: .white,fBold:true,sBold:false,fSize: 14,sSize: 14)
        }
        cell.textLabel?.font = .systemFont(ofSize: 18)
        return cell
    }
   
}
