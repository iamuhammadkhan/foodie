//
//  JSONHelper.swift
//  FoodApp
//
//  Created by Muhammad Khan on 11/11/2020.
//

import Foundation

open class JSONHelper {
    static func parseData<T: Codable>(of type: T.Type, from data: Data) -> T {
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        } catch let err {
            fatalError("Error while parsing data: \(err)")
        }
    }
    
    static func getJSONData(fileName: String, bundle: Bundle, fileExtesion: String = "json") -> Data {
        guard let path = bundle.path(forResource: fileName, ofType: fileExtesion) else {
            fatalError("\(fileName).json not found")
        }
        guard let josnString = try? NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) else {
            fatalError("cant convert \(fileName).json to string")
        }
        guard let jsonData = josnString.data(using: String.Encoding.utf8.rawValue) else {
            fatalError("Unable to convert \(fileName).json to NSData")
        }
        return jsonData
    }
}

public enum JSONMock: String {
    case food = "Food"
    case category = "Category"
    case offers = "Offer"
    
    var data: Data {
        return JSONHelper.getJSONData(fileName: self.rawValue, bundle: Bundle(for: JSONHelper.self), fileExtesion: "json")
    }
}


enum DragDirection {
    
    case Up
    case Down
}
