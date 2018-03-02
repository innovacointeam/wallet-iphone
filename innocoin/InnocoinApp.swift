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
        
        // Request question List from server
        LoginController.shared.getQuestions()
        
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
    

}

