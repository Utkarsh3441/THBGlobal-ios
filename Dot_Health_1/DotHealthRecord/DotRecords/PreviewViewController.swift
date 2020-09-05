//
//  PreviewViewController.swift
//  Dot_Health_1
//
//  Created by Utkarsh Agarwal on 9/2/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import UIKit
import LBTATools

class PreviewViewController: LBTAFormController {

    var encodedBase64String: String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadView()

    }
    
    func setupLoadView() {
       // scrollView.alwaysBounceVertical = true
        //  view.backgroundColor = UIColor(hex: "#d8e5e2")
        view.backgroundColor = UIColor.white
        formContainerStackView.axis = .vertical
        
        formContainerStackView.layoutMargins = .init(top: 25, left: 24, bottom: 30, right: 24)
        
        let imageView = ScaledHeightImageView(image: setImageInImageView())
       // imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
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
        
       // imageView.frame = CGRect(x: 0, y: 0, width: 100, height: screenSize.height - 200)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
