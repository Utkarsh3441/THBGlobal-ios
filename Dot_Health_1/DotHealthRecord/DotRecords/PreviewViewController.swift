//
//  PreviewViewController.swift
//  Dot_Health_1
//
//  Created by Utkarsh Agarwal on 9/2/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit
import LBTATools
import WebKit
import PDFKit

class PreviewViewController: LBTAFormController {

    var encodedBase64String: String?
    var fileName: String?
    var storageLink:String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if storageLink != nil {
            openUploadedDoc()
        } else {
            if checkIfTypeIsImage() == true {
                openPreviewForImage()
            } else {
                openPreviewForDocs()
            }
        }
    }
    
    func openUploadedDoc() {
        
        let url = URL(string: storageLink!)
        if let data = try? Data(contentsOf: url!), let image = UIImage(data: data)  {
            
            view.backgroundColor = UIColor.white
            formContainerStackView.axis = .vertical
            formContainerStackView.layoutMargins = .init(top: 25, left: 24, bottom: 30, right: 24)
      
            let imageView = ScaledHeightImageView(image: image)
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            
            
            let screenHeight = UIScreen.main.bounds.height
            let screenWidth = UIScreen.main.bounds.width
            let width = image.size.width
            let height = image.size.height
            let ratio = width / height
            
            if screenWidth > screenHeight {
                imageView.constrainWidth(screenWidth)
                imageView.constrainHeight(width/ratio)
            } else {
                imageView.constrainWidth(screenHeight*ratio)
                imageView.constrainHeight(screenHeight)
            }
            
            imageView.center = formContainerStackView.center
            formContainerStackView.addArrangedSubview(imageView)
            formContainerStackView.spacing = 12
            let contentRect: CGRect = imageView.subviews.reduce(into: .zero) { rect, view in
                rect = rect.union(view.frame)
            }
            scrollView.contentSize = contentRect.size
        } else {
            formContainerStackView.isHidden = true
            let webView = WKWebView(frame: self.view.frame)
            
            webView.loadFileURL(url!, allowingReadAccessTo: url!)
            webView.center = self.view.center
            self.view.addSubview(webView)
        }
        
    }
    
    func checkIfTypeIsImage()-> Bool {
        
        let  componentsArr = fileName?.components(separatedBy: ".")
        if let fileType = componentsArr?.last {
            
            if fileType.caseInsensitiveCompare("png") == .orderedSame ||  fileType.caseInsensitiveCompare("jpg") == .orderedSame  ||  fileType.caseInsensitiveCompare("jpeg") == .orderedSame {
                return true
            }
        }
        return false
        
    }
    
    func openPreviewForImage() {
        view.backgroundColor = UIColor.white
        formContainerStackView.axis = .vertical
        
        formContainerStackView.layoutMargins = .init(top: 25, left: 24, bottom: 30, right: 24)
        
        let imageView = ScaledHeightImageView(image: setImageInImageView())
        imageView.image = setImageInImageView()

        imageView.contentMode = .scaleAspectFit
        
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        if let width = imageView.image?.size.width , let height = imageView.image?.size.height {
            let ratio = width / height
            
            if screenWidth > screenHeight {
                imageView.constrainWidth(screenWidth)
                imageView.constrainHeight(width/ratio)
            } else {
                imageView.constrainWidth(screenHeight*ratio)
                imageView.constrainHeight(screenHeight)
            }
        }
       imageView.center = formContainerStackView.center
       formContainerStackView.addArrangedSubview(imageView)
         formContainerStackView.spacing = 12
        let contentRect: CGRect = imageView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size
    }
    
    func base64ToImage(base64String: String?) -> UIImage?{
        if (base64String?.isEmpty)! {
            return #imageLiteral(resourceName: "no_image_found")
        }else {
            // Separation part is optional, depends on your Base64String !
            let tempImage = base64String?.components(separatedBy: ",")
            if let data = tempImage?.first {
                let dataDecoded : Data = Data(base64Encoded: data, options: .ignoreUnknownCharacters)!
                let decodedimage = UIImage(data: dataDecoded)
                return decodedimage
            }
        }
        return nil
    }
    
    func setImageInImageView()-> UIImage? {
        
        var image: UIImage? = nil

        guard let encodedString = encodedBase64String else { return image}
        
        if let imageFetch = self.base64ToImage(base64String: encodedString.padding(toLength: ((encodedString.count+3)/4)*4, withPad: "=", startingAt: 0)) {
            
            image = imageFetch
            return image
            
        }
        return image
    }
    
    func base64ToData(string:String)->Data? {
         guard  let fromStringToData = Data(base64Encoded: string, options: .ignoreUnknownCharacters) else {return nil}
        return fromStringToData
    }
    
    func openPreviewForDocs() {
        
        formContainerStackView.isHidden = true
                
        if let docData = self.base64ToData(string: encodedBase64String!.padding(toLength: ((encodedBase64String!.count+3)/4)*4, withPad: "=", startingAt: 0)) {

            let webView = WKWebView(frame: self.view.frame)
            webView.load(docData, mimeType: "application/pdf",
                         characterEncodingName: "utf-8", baseURL:URL(string: "https://www.google.com")!)
            webView.center = self.view.center
            self.view.addSubview(webView)
      
        }
    }
}

class ScaledHeightImageView: UIImageView {

    override var intrinsicContentSize: CGSize {

        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width

            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio

            return CGSize(width: myViewWidth, height: scaledHeight)
        }

        return CGSize(width: -1.0, height: -1.0)
    }

}
