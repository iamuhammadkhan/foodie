//
//  Extension+AppStoryboard.swift
//  FoodApp
//
//  Created by Muhammad Khan on 10/11/2020.
//

import UIKit

extension UIViewController {
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
}
