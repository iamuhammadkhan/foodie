//
//  HomePresenter.swift
//  Fooddie
//
//  Created by Muhammad Khan on 27/12/2020.
//

import Foundation
import RxSwift
import RxCocoa

typealias HomePresenterDependencies = (
    interactor: HomeInteractor,
    router: HomeRouter
)

protocol HomePresenterInputs {
    var getCategoriesAction: PublishSubject<Void> { get }
    var getOffersAction: PublishSubject<Void> { get }
    var cartButtonTappedAction: PublishSubject<Void> { get }
}

protocol HomePresenterOutputs {
    var offers: BehaviorRelay<[ModelOffer]> { get }
    var categories: BehaviorRelay<[ModelCategory]> { get }
    var pages: BehaviorRelay<[ModelPage]> { get }
    var cartItems: BehaviorRelay<Int> { get }
    var selectedPageIndex: BehaviorRelay<Int?> { get }
}

protocol HomePresenterInterface {
    var inputs: HomePresenterInputs { get }
    var outputs: HomePresenterOutputs { get }
}

class HomePresenter: HomePresenterInterface, HomePresenterInputs, HomePresenterOutputs {
    
    var inputs: HomePresenterInputs { return self }
    var outputs: HomePresenterOutputs { return self }
    
    private let dependencies: HomePresenterDependencies
    private let disposeBag = DisposeBag()
    
    //Outputs
    var offers = BehaviorRelay<[ModelOffer]>(value: [])
    var categories = BehaviorRelay<[ModelCategory]>(value: [])
    var selectedPageIndex = BehaviorRelay<Int?>(value: nil)
    var pages = BehaviorRelay<[ModelPage]>(value: [])
    var cartItems = BehaviorRelay<Int>(value: 0)
    
    //Inputs
    var getCategoriesAction = PublishSubject<Void>()
    var getOffersAction = PublishSubject<Void>()
    var cartButtonTappedAction = PublishSubject<Void>()
    
    
    init(dependencies: HomePresenterDependencies) {
        self.dependencies = dependencies
        
        dependencies.interactor.categoriesResult
            .asObservable()
            .subscribe(onNext: { [weak self] val in
                self?.categories.accept(val)
                self?.pages.accept(val.map{ModelPage(with: $0.title, _vc: FoodRouter().viewController(category: $0))})
            })
            .disposed(by: disposeBag)
        
        dependencies.interactor.offersResult
            .asObservable()
            .bind(to: offers)
            .disposed(by: disposeBag)
        
        getCategoriesAction
            .asObservable()
            .bind(to: dependencies.interactor.getCategoriesAction)
            .disposed(by: disposeBag)
        
        getOffersAction
            .asObservable()
            .bind(to: dependencies.interactor.getOffersAction)
            .disposed(by: disposeBag)
        
        cartButtonTappedAction.asObserver()
            .subscribe(onNext: {
                dependencies.router.openCart()
            })
            .disposed(by: disposeBag)
        
        DataHandler.shared.items
            .asObservable()
            .subscribe(onNext: { [weak self] val in
                self?.cartItems.accept(val.count)
            })
            .disposed(by: disposeBag)
        
    }
 

}


/*
 presenter.outputs.pages
     .asObservable()
     .subscribe(onNext: { [weak self] val in
         self?.pageCollection.pages = val
         self?.pageCollection.selectedPageIndex = 0
         for item in val {
             (item.vc as? TabChildVC)?.innerTableViewScrollDelegate = self
         }
         self?.tabBarCollectionView.reloadData()
         if let vc = val.first?.vc {
             self?.pageViewController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
             self?.tabBarCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
         }
     })
     .disposed(by: disposeBag)
 */
