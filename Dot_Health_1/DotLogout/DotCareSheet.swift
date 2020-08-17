//
//  DotCareSheet.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 13/08/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation
class DotCareSheet: UIViewController {
    @IBOutlet weak var tableviews : UITableView!
//    var selectedModel : DotPaymentsModel!
    var arr = Array<Any>()
    var keyMap = NSMutableDictionary()
    var datArr = ["Name","Details 1","Details 2","Details 3","Details 4","Status"]
    var datArr1 = ["Post Operation","Take Medicine at Morning once","Take Medicine at Night once","Take Medicine at Afternoon once","Take Medicine at Evening once","Active"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviews.rowHeight = 80
       
        // Do any additional setup after loading the view.
    }
//    func makeDateArr(){
//        arr.removeAll()
//        keyMap.removeAllObjects()
//        arr.append(selectedModel.tID)
//        keyMap.setValue("Payment ID", forKey: selectedModel.tID)
//        arr.append(selectedModel.price)
//        keyMap.setValue("Price", forKey: selectedModel.price)
//        arr.append(selectedModel.text)
//        keyMap.setValue("Status", forKey: selectedModel.text)
//        arr.append("Help/Support : contact@abc.com")
//
//
//    }
    override func viewWillAppear(_ animated: Bool) {
        tableviews.reloadData()
    }
}
extension DotCareSheet: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datArr.count
    }
  
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let val = "\(datArr[indexPath.row]): "
        let val1 = datArr1[indexPath.row]
        if (val == "Status"){
            
            cell.textLabel?.attributedText = NSAttributedString().createAttributedString(first: val, second: val1, fColor: Theme.gradientColorDark!, sColor: .systemGreen, fBold: true, sBold: true, fSize: 16, sSize: 16)
        }
        else{
            cell.textLabel?.attributedText = NSAttributedString().createAttributedString(first: val, second: val1, fColor: Theme.gradientColorDark!, sColor: .darkGray, fBold: true, sBold: true, fSize: 16, sSize: 16)
        }

        return cell
    }
   
}
