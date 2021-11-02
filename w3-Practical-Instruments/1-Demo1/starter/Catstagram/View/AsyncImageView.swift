//
//  AsyncImageView.swift
//  Catstagram
//
//  Created by Abhiram Krishna on 28/01/21.
//  Copyright © 2021 Luke Parham. All rights reserved.
//

import UIKit

class AsyncImageView: UIView {

    private var _image: UIImage?
    var image: UIImage? {
        get {
            return  _image
        }
        set {
            _image = newValue
            layer.contents = nil
            guard let image = newValue else {
                return
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                let decodedImage = UIImage.decodedImage(image: image)
                DispatchQueue.main.async {
                    self.layer.contents = decodedImage?.cgImage
                }
            }
        }
    }

}
