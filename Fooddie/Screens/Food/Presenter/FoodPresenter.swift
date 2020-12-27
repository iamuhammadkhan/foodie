//
//  FoodPresenter.swift
//  Fooddie
//
//  Created by Muhammad Khan on 27/12/2020.
//

import Foundation
import RxSwift
import RxCocoa

typealias FoodPresenterDependencies = (
    interactor: FoodInteractor,
    router: FoodRouter
)

protocol FoodPresenterInputs {
    var getItems: PublishSubject<Void> { get }
    var addItemToCartAction: PublishSubject<ModelFood> { get }
}

protocol FoodPresenterOutputs {
    var items: BehaviorRelay<[ModelFood]> { get }
}

protocol FoodPresenterInterface {
    
    var inputs: FoodPresenterInputs { get }
    var outputs: FoodPresenterOutputs { get }
}

class FoodPresenter: FoodPresenterInterface, FoodPresenterInputs, FoodPresenterOutputs {
    
    var inputs: FoodPresenterInputs { return self }
    var outputs: FoodPresenterOutputs { return self }
    
    private let dependencies: FoodPresenterDependencies
    private let disposeBag = DisposeBag()
    
    //Outputs
    var items = BehaviorRelay<[ModelFood]>(value: [])
    
    //Inputs
    var getItems = PublishSubject<Void>()
    var addItemToCartAction = PublishSubject<ModelFood>()
    
    init(dependencies: FoodPresenterDependencies) {
        self.dependencies = dependencies
        
        getItems
            .asObservable()
            .bind(to: dependencies.interactor.getItemsAction)
            .disposed(by: disposeBag)
        
        dependencies.interactor.itemsResult
            .asObservable()
            .bind(to: items)
            .disposed(by: disposeBag)
        
        addItemToCartAction
            .asObservable()
            .subscribe(onNext: { [weak self] val in
                dependencies.interactor.addItemToCartAction.onNext(val)
            })
            .disposed(by: disposeBag)
        
    }
 

}
