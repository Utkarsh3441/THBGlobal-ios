//
//  DotMedicinesController.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 21/07/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class DotMedicinesController: UIViewController {
    @IBOutlet weak var tableViw : UITableView!
    
    var arr = ["Days":"14","Dose(day)":"2","Instructions":"Take one after lunch and one after dinner","Status":"On going"]
    var arr1 = ["Days","Dose(day)","Instructions","Status"]
    var keyMap = NSMutableDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViw.rowHeight = 80
        tableViw.backgroundColor = Theme.gradientColorDark
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableViw.reloadData()
    }
}
extension DotMedicinesController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
  
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "med", for: indexPath)
        let key = arr1[indexPath.row]
       
        cell.textLabel?.attributedText = NSAttributedString().createAttributedString(first: "\(key): ", second: "\(arr[key] ?? "")", fColor: .black, sColor: .black,fBold:true,sBold:false,fSize: 17.0,sSize: 17.0)
       
        cell.textLabel?.font = UIFont(name: Theme.mainFontName, size: 18)
        return cell
    }
   
}
