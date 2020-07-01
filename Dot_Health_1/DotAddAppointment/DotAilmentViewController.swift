//
//  DotAilmentViewController.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 25/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class DotAilmentViewController: UIViewController {

    let dummyAilmentData = ["Eye","Nose","Ear","Muscles", "Bone","Skin","Stomach","Chest","Mouth"]
    var selectedAilment = [String]()
    
    var callback : (([String])->())?
    @IBOutlet weak var ailmentTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ailmentTableView.rowHeight = 100
        ailmentTableView.delegate = self
        ailmentTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
   
}


extension DotAilmentViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dummyAilmentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DotAilmentTableViewCell
        cell.setUp(rowValue: dummyAilmentData[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedAilment.contains(dummyAilmentData[indexPath.row]) == false{
            self.selectedAilment.append(dummyAilmentData[indexPath.row])
        }
        callback?(selectedAilment)
        print(selectedAilment)
    }
    
    
}
