//
//  DotRecordsImagePicker+Photos+Camera+extension.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 04/08/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation
import Photos
import UIKit
extension DotRecordsViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate, UNUserNotificationCenterDelegate{

func displayUploadImageDialog(btnSelected: UIButton) {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    let alertController = UIAlertController(title: "", message: "Upload profile photo?".localized, preferredStyle: .actionSheet)
    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action"), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
        alertController.dismiss(animated: true) {() -> Void in }
    })
    alertController.addAction(cancelAction)
    let cameraRollAction = UIAlertAction(title: NSLocalizedString("Open library".localized, comment: "Open library action"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
        if UI_USER_INTERFACE_IDIOM() == .pad {
            OperationQueue.main.addOperation({() -> Void in
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true) {() -> Void in }
            })
        }
        else {
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true) {() -> Void in }
        }
    })
    let cameraAction = UIAlertAction(title: "Camera", style: .default){
        UIAlertAction in
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        } else {
            self.showAlertView("Camera Not Supported", message: "")
          
        }
    }
    alertController.addAction(cameraRollAction)
    alertController.addAction(cameraAction)
    alertController.view.tintColor = .black
    present(alertController, animated: true) {() -> Void in }
}
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imgUrl = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.imageURL.rawValue)] as? URL{
            var new = record(category:(imgUrl.lastPathComponent), file_content: "\(imgUrl)", medical_record_id: 0, patient_id: loginData.user_id ?? 17, storage_link: nil)
            
            guard let image = info[.originalImage] as? UIImage else {
                return
            }
            guard let imageData: Data = image.jpegData(compressionQuality: 0.4) else {
                return
            }
            // let media = MediaModel()
            new.imageContent = imageData
            //                  new.type = "image/jpeg"
            new.record_name = (info[.imageURL] as? URL)?.lastPathComponent
            new.storage_link = (info[.imageURL] as? URL)?.absoluteString 
            
            if let text = docTextField.text, text.count > 0 {
              new.category = text
            } else {
               new.category = "Image"
            }
        
            if recordsDataArray.contains(new) || addedRecords.contains(new){
                self.showAlertView("Duplicate files", message: "File already present")
            }
            else{
                recordsDataArray.append(new)
                addedRecords.append(new)
                applySnapshot(items: recordsDataArray)
            }
            
        }
        self.dismiss(animated: true, completion: nil)
    }
//    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL.rawValue] as? URL{
//            let new = record(category: docTextField.text ?? "", file_content: "\(imgUrl)", medical_record_id: 1, patient_id: 17, storage_link: nil)
//                   recordsDataArray.append(new)
//                   addedRecords.append(new)
//                   applySnapshot(items: recordsDataArray)
//        }
//        
////        let imageName = imageURL.path!.lastPathComponent
////        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
////        let localPath = documentDirectory.stringByAppendingPathComponent(imageName)
////
////        let image = info[UIImagePickerControllerOriginalImage.rawValue] as UIImage
////        let data = UIImagePNGRepresentation(image)
////        data.writeToFile(localPath, atomically: true)
////
////        let imageData = NSData(contentsOfFile: localPath)!
////        let photoURL = NSURL(fileURLWithPath: localPath)
////        let imageWithData = UIImage(data: imageData)!
////    let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as! UIImage
////
//////    profileImage.image = image
////        let imageData = image.jpegData(compressionQuality: 0.05)
////        let images = image.pngData()
//    self.dismiss(animated: true, completion: nil)
//}

func checkPermission() {
    let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    switch authStatus {
    case .authorized:
        self.displayUploadImageDialog(btnSelected: self.downButton)
    case .denied:
        print("Error")
    default:
        break
    }
}

func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.dismiss(animated: true, completion: nil)
}

func checkLibrary() {
    let photos = PHPhotoLibrary.authorizationStatus()
    if photos == .authorized {
        switch photos {
        case .authorized:
            self.displayUploadImageDialog(btnSelected: self.downButton)
        case .denied:
            print("Error")
        default:
            break
        }
    }
}
}
