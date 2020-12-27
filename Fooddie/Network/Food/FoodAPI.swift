//
//  FoodApi.swift
//  FoodApp
//
//  Created by Muhammad Khan on 10/11/2020.
//

import Foundation
import Moya


enum FoodAPI {
    case getOffers
    case getCategories
    case getFilters(categoryId: String)
    case getItems(categoryId: String, keyword: String?)
}

extension FoodAPI: TargetType {
    var baseURL: URL {
        return AppEnvironement.baseURL
    }
    
    var path: String {
        switch self {
        case .getOffers:
            return "/offers"
        case .getCategories:
            return "/categories"
        case .getFilters:
            return "/filters"
        case .getItems:
            return "/meals"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCategories,
             .getFilters,
             .getItems,
             .getOffers:
            return .get
        }
        
    }
    
    var sampleData: Data {
        switch self {
        case .getItems(let categoryId, _):
            var data = JSONMock.food.data
            do {
                var items = try JSONDecoder().decode([ModelFood].self, from: data)
                items = items.filter({$0.categoryId == categoryId})
                data = try JSONEncoder().encode(items)
            }catch {
                print("JSON Error", error)
            }
            return data
        case .getCategories:
            return JSONMock.category.data
        case .getOffers:
            return JSONMock.offers.data
        default: return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .getItems(let categoryId, let keyword):
            let apiParamters = ["category_id": categoryId, "keyword": keyword ?? ""]
            return .requestParameters(parameters: apiParamters, encoding: URLEncoding.default)
        case .getFilters(let categoryId):
            let apiParamters = ["category_id": categoryId]
            return .requestParameters(parameters: apiParamters, encoding: URLEncoding.default)
        case .getCategories, .getOffers:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
