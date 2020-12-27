//
//  CartPresenter.swift
//  FoodApp
//
//  Created by Muhammad Khan on 11/11/2020.
//

import Foundation
import RxSwift
import RxCocoa

typealias CartPresenterDependencies = (
    interactor: CartInteractor,
    router: CartRouter
)

protocol CartPresenterInputs {
    var getItemsAction: PublishSubject<Void> { get }
    var removeItem: PublishSubject<ModelFood> { get }
}

protocol CartPresenterOutputs {
    var totalPrice: BehaviorRelay<String> { get}
    var foodItems: BehaviorRelay<[ModelFood]> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<NSError> { get }
}

protocol CartPresenterInterface {
    var inputs: CartPresenterInputs { get }
    var outputs: CartPresenterOutputs { get }
}


class CartPresenter: CartPresenterInterface, CartPresenterInputs, CartPresenterOutputs {
    
    var inputs: CartPresenterInputs { return self }
    var outputs: CartPresenterOutputs { return self }
    
    
    //MARK:- Outputs
    var getItemsAction = PublishSubject<Void>()
    var removeItem = PublishSubject<ModelFood>()
    
    //MARK:- Outputs
    
    var totalPrice = BehaviorRelay<String>(value: "0 usd")
    var foodItems = BehaviorRelay<[ModelFood]>(value: [])
    var isLoading: Observable<Bool>
    var error: Observable<NSError>
    
    
    private let dependencies: CartPresenterDependencies
    private let disposeBag = DisposeBag()
    
    init(dependencies: CartPresenterDependencies) {
     
        self.dependencies = dependencies
        self.error = dependencies.interactor.error
        self.isLoading = dependencies.interactor.isLoading

        self.getItemsAction
            .asObserver()
            .bind(to: dependencies.interactor.getItemsAction)
            .disposed(by: disposeBag)
        
        dependencies.interactor.foodItemsResult.asObservable()
            .subscribe(onNext: { [weak self] items in
                self?.foodItems.accept(items)
                let price = items.reduce(0) { (res, item) -> Float in
                    return res + item.price
                }
                self?.totalPrice.accept("\(price) usd")
            })
            .disposed(by: disposeBag)
            
        removeItem
            .asObservable()
            .subscribe(onNext: { [weak self] val in
                dependencies.interactor.removeItemAction.onNext(val)
            })
            .disposed(by: disposeBag)
        
    }
    
    deinit {
        print("Presenter Deallocated")
    }
    
}
