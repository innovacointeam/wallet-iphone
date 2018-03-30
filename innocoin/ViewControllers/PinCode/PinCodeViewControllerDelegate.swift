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
        let size = PincodeViewController.pefferedSize
        let frame = CGRect(origin: CGPoint.zero, size: size)
        let container = UIView(frame: frame)
        container.center = view.center
        view.addSubview(container)
        let centerX = NSLayoutConstraint(item: container,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: view,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0)
        
        let centerY = NSLayoutConstraint(item: container,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: view,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0)
        
        view.addConstraints([centerX, centerY])
        centerY.isActive = true
        centerX.isActive = true
        
        container.layoutIfNeeded()
        
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

