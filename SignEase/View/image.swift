//
//  image.swift
//  SignEase
//
//  Created by Lawal Abdulganiy on 12/05/2023.
//

import UIKit

class Image1 {
    static let shared = Image1()
    
    var image: UIImage? {
        didSet {
            if let image = image {
                print("Image changed to \(image)")
            }
        }
    }
    
    init(image: UIImage? = nil) {
        self.image = image
    }

    func setImage(image: UIImage?) {
        self.image = image
    }
}
