//
//  Extension+UIImageView.swift
//  FoodApp
//
//  Created by Muhammad Khan on 10/11/2020.
//

import UIKit.UIImageView
import Kingfisher

extension UIImageView {
    
    @IBInspectable
    var imageUrl: String {
        get {
            return ""
        }
        set {
            let url = URL(string: newValue)
            self.kf.setImage(with: url, placeholder: UIImage())
        }
    }
    
    @IBInspectable
    var imageColor: UIColor? {
        get {
            if let color = self.tintColor {
                return UIColor(cgColor: color.cgColor)
            }
            return nil
        }
        set {
            if let color = newValue {
                let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
                self.image = templateImage
                self.tintColor = color
            }
        }
    }
    
}
