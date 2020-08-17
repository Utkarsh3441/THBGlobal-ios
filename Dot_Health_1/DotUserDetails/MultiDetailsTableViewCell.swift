//
//  MultiDetailsTableViewCell.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 12/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit
@objc protocol MultiTableViewDelegate: NSObjectProtocol{

    func afterClickingReturnInTextFields(cell: MultiDetailsTableViewCell)
}
class MultiDetailsTableViewCell: UITableViewCell,UITextFieldDelegate {
    @IBOutlet weak var firstText: UITextField!
    @IBOutlet weak var first: UILabel!
     @IBOutlet weak var yesButton: UIButton!
     @IBOutlet weak var noButton: UIButton!
    var row = 0
      var section = 0
     weak var tableViewDelegate: MultiTableViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        firstText.isHidden = true
        firstText.delegate = self
    }
    @objc func tapDone(sender: Any) {

           tableViewDelegate?.afterClickingReturnInTextFields(cell: self)
          
             self.endEditing(true)
              
}
    @IBAction func textEnd(_ sender: UITextField) {

//        tableViewDelegate?.afterClickingReturnInTextFields(cell: self)
               
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var enable : String {
        get{
            if noButton.imageView?.image?.imageAsset == UIImage(systemName: "checkmark.circle")?.imageAsset{
                return "NO"
            }
            else{
                return "YES"
            }
        }
    }
    var textString: String = "" {
    
         didSet {
               
                   firstText.text = textString
               
           }
       }
    func makeYesEnabled(){
        firstText.isHidden = false
        self.yesButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        self.noButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
         firstText.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
    }
    func makeNoEnabled(){
       firstText.isHidden = true
        self.noButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        self.yesButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
    }
    @IBAction func startEdit(_ sender: UIButton) {
        switch sender.tag {
        case 0:
//            if yesButton.imageView?.image?.imageAsset == UIImage(systemName: "checkmark.circle")?.imageAsset{
//
//
//                self.yesButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
//                self.noButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
//
//            }
//            else if yesButton.imageView?.image?.imageAsset == UIImage(systemName: "checkmark.circle.fill")?.imageAsset{
                makeNoEnabled()
//            }
        case 1:
//            if noButton.imageView?.image?.imageAsset == UIImage(systemName: "checkmark.circle")?.imageAsset{
//                self.firstText.borderStyle = .roundedRect
//
//                self.noButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
//                self.yesButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
//            }
//            else if noButton.imageView?.image?.imageAsset == UIImage(systemName: "checkmark.circle.fill")?.imageAsset{
                makeYesEnabled()
//            }
        

        default:
            print("nithing")
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          firstText.resignFirstResponder()
          return true
      }
      func textFieldDidEndEditing(_ textField: UITextField) {
          firstText = textField
      }

}
