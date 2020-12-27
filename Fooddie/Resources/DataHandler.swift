//
//  DataHandler.swift
//  FoodApp
//
//  Created by Muhammad Khan on 12/11/2020.
//

import Foundation

import RxCocoa
import RxSwift

class DataHandler {
    
    static var shared = DataHandler()
    
    var items = BehaviorRelay<[ModelFood]>(value: [])
    
    private init(){
        
    }
    
}
