//
//  CartInteractor.swift
//  FoodApp
//
//  Created by Muhammad Khan on 11/11/2020.
//

import Foundation
import RxSwift
import RxCocoa
import Moya



class CartInteractor {
    
    fileprivate let provider = MoyaProvider<FoodAPI>(stubClosure: MoyaProvider.delayedStub(0.5), plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    var getItemsAction = PublishSubject<Void>()
    var removeItemAction = PublishSubject<ModelFood>()
    
    var foodItemsResult = BehaviorRelay<[ModelFood]>(value: [])
    
    let isLoading: PublishSubject<Bool> = PublishSubject()
    let error: PublishSubject<NSError> = PublishSubject()
    
    private let disposeBag = DisposeBag()
    
    init() {
        
        getItemsAction.asObserver()
            .subscribe(onNext: { 
                var temp = [ModelFood]()
                DataHandler.shared.items.value.forEach { item in
                    let contains = temp.contains { (item1) -> Bool in
                        return item1.id == item.id
                    }
                    if !contains {
                        temp.append(item)
                    }
                }
                self.foodItemsResult.accept(temp)
            })
            .disposed(by: disposeBag)
        
        DataHandler.shared.items
            .asObservable()
            .subscribe(onNext: { [weak self] val in
                var temp = [ModelFood]()
                val.forEach { item in
                    let contains = temp.contains { (item1) -> Bool in
                        return item1.id == item.id
                    }
                    if !contains {
                        temp.append(item)
                    }
                }
                self?.foodItemsResult.accept(temp)
            })
            .disposed(by: disposeBag)
        
        removeItemAction
            .asObservable()
            .subscribe(onNext: { [weak self] val in
                var array = DataHandler.shared.items.value
//                let index = array.firstIndex { (item) -> Bool in
//                    return item.categoryId == val.categoryId
//                }
//                if let indexModified = index {
//                    array.remove(at: indexModified)
//                }
                array.removeAll { (item) -> Bool in
                    return item.categoryId == val.categoryId
                }
                DataHandler.shared.items.accept(array)
            })
            .disposed(by: disposeBag)
        
    }
    
    deinit {
        print("Interactor Deallocated")
    }
}



