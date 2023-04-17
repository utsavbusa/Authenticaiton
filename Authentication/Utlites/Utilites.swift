//
//  Utilites.swift
//  Authentication
//
//  Created by Utsav busa on 16/04/23.
//

import Foundation
import UIKit

final class Utilites{
    static let shared = Utilites()
    private init(){
        
    }
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        
        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
        if let navigationControoller = controller as? UINavigationController{
            return topViewController(controller: navigationControoller.visibleViewController)
        }
        if let tabController = controller as? UITabBarController{
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController (controller: presented)
        }
        return controller
        
    }
}
