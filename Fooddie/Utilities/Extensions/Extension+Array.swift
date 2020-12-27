//
//  Extension+Array.swift
//  Fooddie
//
//  Created by Muhammad Khan on 27/12/2020.
//

import Foundation

extension Array {
    
    func item<T>(at index: Int) -> T?{
        if count > index {
            return self[index] as? T
        }
        return nil
    }
    
}
