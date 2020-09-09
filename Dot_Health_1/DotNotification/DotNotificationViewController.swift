//
//  DotNotificationViewController.swift
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 14/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit

class DotNotificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Notification"
        self.navigationController?.navigationBar.barTintColor = Theme.accentColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        
        let label = UILabel()
        label.text = "Work In Progress"
        label.font = UIFont.boldSystemFont(ofSize: 25) // my custom font
        label.textColor = UIColor.systemBlue // my custom colour
        self.view.addSubview(label)
        label.center(in: self.view)
       
        
        // Do any additional setup after loading the view.
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
