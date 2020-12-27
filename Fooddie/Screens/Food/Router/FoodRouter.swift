//
//  FoodRouter.swift
//  Fooddie
//
//  Created by Muhammad Khan on 27/12/2020.
//

import UIKit.UIViewController

class FoodRouter {
    
    private(set) weak var vc: UIViewController!
    
    init() {
        
    }
    
    init(viewController: UIViewController) {
        self.vc = viewController
    }
    
    func viewController(category: ModelCategory) -> FoodVC {
        let vc = FoodVC()
        let interactor = FoodInteractor()
        interactor.category.accept(category)
        let router = FoodRouter(viewController: vc)
        let dependencies = FoodPresenterDependencies(interactor: interactor, router: router)
        let presenter = FoodPresenter(dependencies: dependencies)
        vc.presenter = presenter
        return vc
    }
    
//    func showVC(from parent: UIViewController){
//        let vc = viewController()
//        if let nav = parent.navigationController {
//            nav.pushViewController(vc, animated: true)
//        }else{
//            parent.present(vc, animated: true, completion: nil)
//        }
//    }
    
//    func openCart(){
//        CartRouter().showVC(from: self.vc)
//    }
    
}
