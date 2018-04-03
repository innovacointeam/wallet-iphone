//
//  PinCodeViewControllerDelegate.swift
//  innocoin
//
//  Created by Yuri Drigin on 23.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation
import UIKit

protocol PincodeViewControllerDelegate {
    
    var pincodeContainer: UIView! { get set }
    var pincodeController: PincodeViewController! { get set }
    func didEnter(pin: String?)

}

extension PincodeViewControllerDelegate where Self: UIViewController {
    
    func createPincodeContainer() -> UIView {
        let container = UIView(frame: CGRect(origin: CGPoint.zero, size: PincodeViewController.pefferedSize))
        view.addSubview(container)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: PincodeViewController.pefferedSize.height).isActive = true
        container.widthAnchor.constraint(equalToConstant: PincodeViewController.pefferedSize.width).isActive = true
        
        view.layoutIfNeeded()
        
        container.layer.shadowColor = UIColor.placeholderTextColor.cgColor
        container.layer.shadowRadius = 10
        container.layer.shadowOpacity = 0.6
        container.layer.shadowOffset = CGSize(width: 3, height: 3)
        container.layer.masksToBounds = false
        container.backgroundColor = UIColor.clear
        
        return container
    }
    
    func appearPincodeController() -> PincodeViewController  {
        guard pincodeController == nil else {
            add(chield: pincodeController, in: pincodeContainer)
            return pincodeController
        }
        let controller = UIStoryboard.pincodeViewController
        controller.delegate = self
        add(chield: controller, in: pincodeContainer)
        return controller
    }
    
    func disapearPincodeController() {
        guard pincodeContainer?.superview != nil else {
            return
        }
        remove(chield: pincodeController)
        pincodeContainer.removeFromSuperview()
    }
}

