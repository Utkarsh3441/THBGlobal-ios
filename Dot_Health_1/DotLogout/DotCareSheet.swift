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
    var selectedModel : DotCarePlanModel!
    var arr = Array<Any>()
    var dataItems: DotCarePlanModel?
    var datArr = ["Name","Details 1","Details 2","Details 3","Details 4"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableviews.rowHeight = 80
        // Do any additional setup after loading the view.
    }
    func makeDateArr(){
        arr.removeAll()
        arr.append(selectedModel.name ?? "")
        arr.append(selectedModel.details_one ?? "")
        arr.append(selectedModel.details_two ?? "")
        arr.append(selectedModel.details_three ?? "")
        arr.append(selectedModel.details_four ?? "")
        arr.append(selectedModel.careplan_date ?? "")
    }
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
        if let val1 = arr[indexPath.row] as? String {
        
        if (val == "Status"){
            
            cell.textLabel?.attributedText = NSAttributedString().createAttributedString(first: val, second: val1, fColor: Theme.gradientColorDark!, sColor: .systemGreen, fBold: true, sBold: true, fSize: 16, sSize: 16)
        }
        else{
            cell.textLabel?.attributedText = NSAttributedString().createAttributedString(first: val, second: val1, fColor: Theme.gradientColorDark!, sColor: .darkGray, fBold: true, sBold: true, fSize: 16, sSize: 16)
        }
    }

        return cell
    }
   
}
