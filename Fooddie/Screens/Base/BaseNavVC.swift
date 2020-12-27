//
//  BaseNavVC.swift
//  Fooddie
//
//  Created by Muhammad Khan on 27/12/2020.
//

import UIKit

class BaseNavVC : UINavigationController {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.tintColor = UIColor.black
        
    }
    
}
