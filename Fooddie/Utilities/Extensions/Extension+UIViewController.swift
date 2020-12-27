//
//  Extension+UIStoryboard.swift
//  FoodApp
//
//  Created by Muhammad Khan on 10/11/2020.
//

import UIKit

extension UIViewController {
    
    class var identifier : String {
        return "\(self)"
    }
    
    func showVC(_ vc: UIViewController, completion: (() -> Void)? = nil){
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        }else{
            self.present(vc, animated: true, completion: completion)
        }
    }
    
    func back(completion: (() -> Void)? = nil){
        DispatchQueue.main.async{
            if let nav = self.navigationController {
                if nav.viewControllers.count == 1{
                    nav.dismiss(animated: true, completion: completion)
                }else{
                    nav.popViewController(animated: true)
                }
            }else{
                self.dismiss(animated: true, completion: completion)
            }
        }
    }
    
    var identifier : String {
        return String(NSStringFromClass(self.classForCoder).split(separator: ".").last ?? "").replacingOccurrences(of: "ViewController", with: "")
    }
    
}
