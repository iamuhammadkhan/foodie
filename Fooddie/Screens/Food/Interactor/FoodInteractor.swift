//
//  FoodInteractor.swift
//  Fooddie
//
//  Created by Muhammad Khan on 27/12/2020.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class FoodInteractor {
    
    fileprivate let provider = MoyaProvider<FoodAPI>()
    
    private let disposeBag = DisposeBag()
    
    var getItemsAction = PublishSubject<Void>()
    var addItemToCartAction = PublishSubject<ModelFood>()
    
    var itemsResult = BehaviorRelay<[ModelFood]>(value: [])
    
    var category = BehaviorRelay<ModelCategory?>(value: nil)
    
    
    init() {
        
        getItemsAction
            .asObservable()
            .subscribe(onNext: { [weak self] in
                if (self?.itemsResult.value ?? []).isEmpty {
                    self?.getItems()
                }else{
                    self?.itemsResult.accept(self?.itemsResult.value ?? [])
                }
            })
            .disposed(by: disposeBag)
        
        addItemToCartAction
            .asObservable()
            .subscribe(onNext: {val in
                var array = DataHandler.shared.items.value
                array.append(val)
                DataHandler.shared.items.accept(array)
            })
            .disposed(by: disposeBag)
        
    }
    
    
    func getItems(){
        guard let id = category.value?.id else{return}
        provider.rx.request(.getItems(categoryId: id, keyword: nil))
            .asObservable()
            .retry(2)
            .filterSuccessfulStatusCodes()
            .map([ModelFood].self)
            .subscribe(onNext: { [weak self] val in
                self?.itemsResult.accept(val)
            }, onError: { [weak self] error in
                do {
                    let data = JSONMock.food.data
                    var items = try JSONDecoder().decode([ModelFood].self, from: data)
                    items = items.filter({$0.categoryId == id})
                    self?.itemsResult.accept(items)
                }catch {
                    print("JSON Error", error)
                }
            })
            .disposed(by: disposeBag)
    }
    
}
