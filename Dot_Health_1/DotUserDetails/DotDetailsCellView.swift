//
//  DotDetailsCellView.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 11/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit
@objc protocol TableViewDelegate: NSObjectProtocol{

    func afterClickingReturnInTextField(cell: DotDetailsCellView)
}
class DotDetailsCellView: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var buttonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailText: UITextField!
    @IBOutlet weak var first: UILabel!
    @IBOutlet weak var textView: UITextView!
    weak var tableViewDelegate: TableViewDelegate?
    var isExpand : Bool?
    var expandableRows = [Any]()
    var retainRows : [String:[Any]]?
    var row = 0
    var section = 0
    @IBAction func startEdit(_ sender: Any) {
        if self.detailText.isEnabled{
            self.detailText.borderStyle = .none
            self.detailText.isEnabled = false
        }
        else{
            self.detailText.borderStyle = .roundedRect
            self.detailText.isEnabled = true
        }
    }
    @IBAction func tapHerre(_ sender: UITextField) {
        }
    func addDone(){
        textView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
    }
    @IBOutlet weak var indicatorButton: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
       
        detailText.delegate = self
        textView.delegate = self
        textView.isEditable = false
    }
    @objc func tapDone(sender: Any) {

         tableViewDelegate?.afterClickingReturnInTextField(cell: self)
        
           self.endEditing(true)
            
       }
    /// Custom setter so we can initialize the height of the text view
    var textString: String {
        get {
            return textView?.text ?? ""
        }
        set {
            if let textView = textView {
                textView.text = newValue
                textView.delegate?.textViewDidChange?(textView)
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            textView?.becomeFirstResponder()
        } else {
            textView?.resignFirstResponder()
        }
        // Configure the view for the selected state
    }
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       detailText.resignFirstResponder()
       return true
   }
   func textFieldDidEndEditing(_ textField: UITextField) {
       detailText = textField
   }
}
extension DotDetailsCellView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
    
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        
        // Resize the cell only when cell's size is changed
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            
            if let thisIndexPath = tableView?.indexPath(for: self) {
                tableView?.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}
extension UITableViewCell {
    /// Search up the view hierarchy of the table view cell to find the containing table view
    var tableView: UITableView? {
        get {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }

            return table as? UITableView
        }
    }
}
