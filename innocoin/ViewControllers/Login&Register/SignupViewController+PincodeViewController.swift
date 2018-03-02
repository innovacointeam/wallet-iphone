//
//  SignupViewController+PincodeViewController.swift
//  innocoin
//
//  Created by Yuri Drigin on 27.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation
import UIKit

extension SignUpViewController: PincodeViewControllerDelegate {
    
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
    
    func appearPincodeController() -> PincodeViewController {
        guard pincodeController == nil else {
            return pincodeController
        }
        let controller = storyboard!.instantiateViewController(withIdentifier: "PincodeViewController") as! PincodeViewController
        controller.delegate = self
        add(chield: controller, in: pincodeContainer)
        return controller
    }
    
    func didEnter(pin: String?) {
        transactionPasswordField.text = pin
        remove(chield: pincodeController)
        pincodeContainer.removeFromSuperview()
        pincodeController = nil
    }
}
