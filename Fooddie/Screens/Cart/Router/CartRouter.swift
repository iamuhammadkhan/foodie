//
//  CartRouter.swift
//  FoodApp
//
//  Created by Muhammad Khan on 11/11/2020.
//

import UIKit.UIViewController

class CartRouter {
    
    private(set) weak var vc: UIViewController!
    
    init() {
        
    }
    
    init(viewController: UIViewController) {
        self.vc = viewController
    }
    
    private func viewController() -> CartVC {
        let vc = CartVC.instantiate(fromAppStoryboard: .Main)
        let interactor = CartInteractor()
        let router = CartRouter(viewController: vc)
        let dependencies = CartPresenterDependencies(interactor: interactor, router: router)
        let presenter = CartPresenter(dependencies: dependencies)
        vc.presenter = presenter
        return vc
    }
    
    func showVC(from parent: UIViewController){
        let vc = viewController()
        if let nav = parent.navigationController {
            nav.pushViewController(vc, animated: true)
        }else{
            parent.present(vc, animated: true, completion: nil)
        }
    }
    
    func openCart(from parent: UIViewController){
//        let vc = CartVC.instantiate(fromAppStoryboard: .Main)
//        parent.present(vc, animated: true, completion: nil)
    }
    
}
