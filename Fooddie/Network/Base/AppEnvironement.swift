//
//  AppEnvironement.swift
//  FoodApp
//
//  Created by Muhammad Khan on 10/11/2020.
//

import Foundation

enum AppEnvironement : String {
    
    case production
    case development
    
    static var currentState: AppEnvironement {
        return .development
    }
    
    static var baseURL: URL {
        switch currentState {
        case .production:
            return URL(string: "192.168.10.4:3000")!
        case .development:
            return URL(string: "192.168.10.4:3000")!
        }
    }

    static var showLog: Bool {
        switch currentState {
        case .production:
            return false
        case .development:
            return true
        }
    }

}
