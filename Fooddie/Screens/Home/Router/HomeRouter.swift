//
//  HomeRouter.swift
//  Fooddie
//
//  Created by Muhammad Khan on 27/12/2020.
//

import UIKit.UIViewController

class HomeRouter {
    
    private(set) weak var vc: UIViewController!
    
    init() {
        
    }
    
    init(viewController: UIViewController) {
        self.vc = viewController
    }
    
    func viewController() -> HomeVC {
        let vc = HomeVC()//.instantiate(fromAppStoryboard: .Main)
        let interactor = HomeInteractor()
        let router = HomeRouter(viewController: vc)
        let dependencies = HomePresenterDependencies(interactor: interactor, router: router)
        let presenter = HomePresenter(dependencies: dependencies)
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
    
    func openCart(){
        CartRouter().showVC(from: self.vc)
    }
    
}
