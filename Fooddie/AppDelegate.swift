//
//  AppDelegate.swift
//  Fooddie
//
//  Created by Muhammad Khan on 27/12/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window?.rootViewController = HomeRouter().viewController()
        return true
    }


}

