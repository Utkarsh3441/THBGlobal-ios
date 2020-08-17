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
    var ailmentData = [ailment]()
    var servicesData = [service]()
    var selectedData = ""
    var selectedAilmentServiceArray = [[String:Any]]()
    
    var callback : (([[String:Any]])->())?
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
        switch selectedData{
        case "Ailment": return ailmentData.count
        case "Services":return servicesData.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DotAilmentTableViewCell
        var cellValue = ""
        switch selectedData{
        case "Ailment":cellValue = ailmentData[indexPath.row].ailment
        case "Services":cellValue = servicesData[indexPath.row].service
        default:
            cellValue = kblankString
        }
        cell.setUp(rowValue: cellValue)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        var cellValue = ""
        var ailmentServiceId = 0
        var selectedAilmentService = [String:Any]()
        switch selectedData{
        case "Ailment":
            cellValue = ailmentData[indexPath.row].ailment
            ailmentServiceId = ailmentData[indexPath.row].ailment_id
            selectedAilmentService["name"] = cellValue
            selectedAilmentService["id"] = ailmentServiceId
            
        case "Services":
            cellValue = servicesData[indexPath.row].service
            ailmentServiceId = servicesData[indexPath.row].service_id
            selectedAilmentService["name"] = cellValue
            selectedAilmentService["id"] = ailmentServiceId
        default:
            print("Nothing selected")
        }
        if !selectedAilmentServiceArray.contains(where: { $0["name"] as? String == cellValue}){
            self.selectedAilmentServiceArray.append(selectedAilmentService)
            cell.accessoryType = .checkmark
        }
        else{
            print("deselect row")
             cell.accessoryType = .none
            selectedAilmentServiceArray.removeAll{$0["name"] as? String == cellValue}
        }
        //let selectedList = Array(selectedAilmentServiceArray.map({$0.keys}))
        callback?(selectedAilmentServiceArray)
        print("Selected ailment:",selectedAilmentServiceArray)
    }
    
    
}
