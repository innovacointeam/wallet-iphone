//
//  AppDelegate.swift
//  innocoin
//
//  Created by Yuri Drigin on 21.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

@UIApplicationMain
class InnocoinApp: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var mainTabBar: MainTabBarController? {
        return window?.rootViewController as? MainTabBarController
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Apply app theme
        UINavigationBar.appearance().barTintColor = UIColor.backgroundStatusBar
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        UIApplication.shared.statusBarStyle = .lightContent
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.clear
        
        // Request question List from server
        LoginController.shared.getQuestions()
        MarketPriceController.shared.fetchNew()
        
        return true
    }
    
    @discardableResult func setRoot(controllerName: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: controllerName)
        
        guard let window = window,
            let rootVC = window.rootViewController else {
            fatalError("Set root view controller without current")
        }
        
        controller.view.frame = rootVC.view.frame
        controller.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3,
                          options: .transitionFlipFromRight,
                          animations: {
                          window.rootViewController = controller
        }, completion: nil)

        return controller
    }
    
    func setRoot(_ controller: UIViewController, options: UIViewAnimationOptions = .transitionFlipFromRight)  {
        guard let window = window,
            let rootVC = window.rootViewController else {
                fatalError("Set root view controller without current")
        }
        
        controller.view.frame = rootVC.view.frame
        controller.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3,
                          options: options,
                          animations: {
                            window.rootViewController = controller
        }, completion: nil)
    }
    
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version) build \(build)"
    }

}

