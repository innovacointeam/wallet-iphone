//
//  UIView+extension.swift
//  innocoin
//
//  Created by Yuri Drigin on 21.02.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import UIKit

extension UIView {
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]? = nil) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds

        
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}
