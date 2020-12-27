//
//  PageModel.swift
//  Fooddie
//
//  Created by Muhammad Khan on 27/12/2020.
//

import UIKit

struct ModelPage {
    
    var name = ""
    var vc = UIViewController()
    
    init(with _name: String, _vc: UIViewController) {
        
        name = _name
        vc = _vc
    }
}

struct PageCollection {
    
    var pages = [ModelPage]()
    var selectedPageIndex = 0 //The first page is selected by default in the beginning
}
