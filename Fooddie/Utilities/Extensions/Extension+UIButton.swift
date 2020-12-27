//
//  Extension+UIButton.swift
//  FoodApp
//
//  Created by Muhammad Khan on 10/11/2020.
//

import UIKit.UIButton
import Kingfisher

extension UIButton {
    
    @IBInspectable
    var imageUrl: String {
        get {
            return ""
        }
        set {
            let url = URL(string: newValue)
            self.kf.setImage(with: url, for: .normal, placeholder: #imageLiteral(resourceName: "PlaceholderImage"))
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
                if var templateImage = self.image(for: .normal) {
                    templateImage = templateImage.withRenderingMode(.alwaysTemplate)
                    self.setImage(templateImage, for: .normal)
                    self.tintColor = color
                }
                
            }
        }
    }
    
}

