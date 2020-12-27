//
//  Extension+UIFont.swift
//  Fooddie
//
//  Created by Muhammad Khan on 27/12/2020.
//

import UIKit

extension UIFont {
    static func bold(_ size: CGFloat) -> UIFont{
        return UIFont(name: "Montserrat-Bold", size: size) ?? .systemFont(ofSize: size, weight: .bold)
    }
    static func semiBold(_ size: CGFloat) -> UIFont{
        return UIFont(name: "Montserrat-SemiBold", size: size) ?? .systemFont(ofSize: size, weight: .semibold)
    }
    static func medium(_ size: CGFloat) -> UIFont{
        return UIFont(name: "Montserrat-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)
    }
    static func regular(_ size: CGFloat) -> UIFont{
        return UIFont(name: "Montserrat-Regular", size: size) ?? .systemFont(ofSize: size, weight: .regular)
    }
    static func light(_ size: CGFloat) -> UIFont{
        return UIFont(name: "Montserrat-Light", size: size) ?? .systemFont(ofSize: size, weight: .light)
    }
}

