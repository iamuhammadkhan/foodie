//
//  ViewController.swift
//  Fooddie
//
//  Created by Muhammad Khan on 27/12/2020.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setViewControllers([HomeRouter().viewController()], animated: true)
    }
}
