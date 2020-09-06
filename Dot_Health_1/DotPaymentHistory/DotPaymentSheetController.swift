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
    var arrHeader = Array<String>()
    var arrValue = Array<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViw.rowHeight = 80
        tableViw.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    func makeDateArr(){
        arrValue.removeAll()
        arrHeader.removeAll()
        arrValue.append(selectedModel.amount)
        arrHeader.append("Amount:           $")
        arrValue.append(String(selectedModel.discountPercentage))
        arrHeader.append("Discount (%):         ")
        arrValue.append(String(selectedModel.convenienceFee))
        arrHeader.append("Convinience Fee:      $")
        arrValue.append(String(selectedModel.grossTotal))
        arrHeader.append("Gross Total:        $")
        arrValue.append(selectedModel.status)
        arrHeader.append("Status:           ")
    }
    override func viewWillAppear(_ animated: Bool) {
        tableViw.reloadData()
    }
}
extension DotPaymentSheetController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrValue.count
    }
  
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let val = arrHeader[indexPath.row]
        let val1 = arrValue[indexPath.row]

        
        cell.textLabel?.attributedText = NSAttributedString().createAttributedString(first: val, second: val1, fColor: Theme.gradientColorDark!, sColor: .darkGray, fBold: true, sBold: true, fSize: 16, sSize: 16)
        return cell
    }
   
}
