//
//  HomeInteractor.swift
//  Fooddie
//
//  Created by Muhammad Khan on 27/12/2020.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class HomeInteractor {
    
    fileprivate let provider = MoyaProvider<FoodAPI>()
    
    private let disposeBag = DisposeBag()
    
    var getCategoriesAction = PublishSubject<Void>()
    var getOffersAction = PublishSubject<Void>()
    
    var categoriesResult = BehaviorRelay<[ModelCategory]>(value: [])
    var offersResult = BehaviorRelay<[ModelOffer]>(value: [])
    
    var selectedPageIndex = 0
    
    
    init() {
        
        getCategoriesAction
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.getCategories()
            })
            .disposed(by: disposeBag)
        
        getOffersAction
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.getOffers()
            })
            .disposed(by: disposeBag)
        
    }
    
    
    func getCategories(){
        provider.rx.request(.getCategories)
            .asObservable()
            .retry(2)
            .filterSuccessfulStatusCodes()
            .map([ModelCategory].self)
            .subscribe(onNext: { val in
                self.categoriesResult.accept(val)
            }, onError: { error in
                let decoder = JSONDecoder()
                let models = try! decoder.decode([ModelCategory].self, from: JSONMock.category.data)
                self.categoriesResult.accept(models)
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func getOffers(){
        provider.rx.request(.getOffers)
            .asObservable()
            .retry(2)
            .filterSuccessfulStatusCodes()
            .map([ModelOffer].self)
            .subscribe(onNext: { val in
                self.offersResult.accept(val)
            }, onError: { error in
                let decoder = JSONDecoder()
                let models = try! decoder.decode([ModelOffer].self, from: JSONMock.offers.data)
                self.offersResult.accept(models)
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
}
